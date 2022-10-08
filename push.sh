#!/bin/bash
echo "Push Action started"
abspath(){
    echo "$(cd "$1" && pwd)"
}

# check if branch exist on remote
branch_exist(){
    echo "Checking if branch ($INPUT_BRANCH) exist on remote"
    git ls-remote --heads origin $INPUT_BRANCH > /dev/null 2>&1
}
# call branch_exist
branch_exist


DOT_GIT_DIR="$(git -C "$INPUT_DIR" rev-parse --git-dir)"
if [[ ! -f "$DOT_GIT_DIR"/config && -d "$DOT_GIT_DIR"/.git ]]; then
    # incorrectly configured GIT_DIR
    DOT_GIT_DIR="$DOT_GIT_DIR"/.git
fi
DOT_GIT_DIR="$(abspath "$DOT_GIT_DIR")"

TEMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t tempdir)"
cp -rT "${INPUT_DIR%%+(/)}" "${TEMP_DIR%%+(/)}"
rm -rf "$TEMP_DIR"/.git

TEMP_REPO="$(mktemp -d 2>/dev/null || mktemp -d -t temprepo)"
pushd "$TEMP_REPO"

git init
git config user.name "$INPUT_NAME"
git config user.email "$INPUT_EMAIL"
git remote add local file://"$DOT_GIT_DIR"
if [[ "$INPUT_HISTORY" == true ]]; then
    git -C "$DOT_GIT_DIR" fetch --depth=1 origin "$INPUT_BRANCH":"$INPUT_BRANCH" \
    && git fetch --depth=1 local "$INPUT_BRANCH":"$INPUT_BRANCH" \
    && git checkout "$INPUT_BRANCH" || :
    git ls-files -z | xargs -0 git rm
fi
git branch -M "$INPUT_BRANCH"

cp -rT "${TEMP_DIR%%+(/)}" "${TEMP_REPO%%+(/)}"
rm -rf "$TEMP_DIR"

if [[ -n "$INPUT_CNAME" ]]; then
    echo "$INPUT_CNAME" > CNAME
fi
if [[ "$INPUT_NOJEKYLL" == true ]]; then
    touch .nojekyll
fi

git add . && git commit -m "${INPUT_MESSAGE}" || :
git push --force local "$INPUT_BRANCH":"$INPUT_BRANCH"

popd
rm -rf "$TEMP_REPO"

if [[ "$INPUT_FORCE" == true || "$INPUT_HISTORY" == false ]]; then
    git -C "$DOT_GIT_DIR" push --force origin "$INPUT_BRANCH":"$INPUT_BRANCH"
else
    git -C "$DOT_GIT_DIR" push origin "$INPUT_BRANCH":"$INPUT_BRANCH"
fi
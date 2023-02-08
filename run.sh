newDir=/Users/liang/Desktop/OldProjects
function work() {
    # echo  "$(pwd)/${1}";
    echo $1
    oldDir="/Users/liang/Desktop/OldProject/$1"
    echo $oldDir
    cp -R $oldDir $newDir
    rm -rf $1/.git
    rm -rf $1/$1.xcworkspace
    rm -rf $1/Podfile.lock
    rm -rf $1/Pods
    git checkout --orphan $1
    git add ./$1
    git commit -m "$1-init"
    git push origin $1 --progress
}

for file in $(ls /Users/liang/Desktop/OldProject); do
    work $file
done

exec = require('child_process').exec

src_dir = "./src"
target_dir = "./out"
target_name = "JuzJS.js"
src_files = [
    "node"
    "IDManager"
    "PhysicsEngine"
    "Vector"
]

option "-w", "--watch", "自動ビルド"

task "build", "ビルド", (options)->

    fileList = for filename in src_files
        console.log filename
        src_dir + '/' + filename
    files = fileList.join(' ')

    target = target_dir + '/' + target_name

    args = []
    args.push "--bare"
    args.push "--watch" if options.watch
    args.push "--join " + target
    args.push "--compile " + files

    exec "coffee " + args.join(" "), (err, stdout, stderr)->

        console.log err if err
        console.log stdout if stdout
        console.log stderr if stderr

        if err
            console.log "ビルド失敗"
        else
            console.log "ビルド成功"

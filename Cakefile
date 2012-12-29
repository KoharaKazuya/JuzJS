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


task "build", "ビルド", ->

    fileList = for filename in src_files
        console.log filename
        src_dir + '/' + filename
    files = fileList.join(' ')

    target = target_dir + '/' + target_name

    exec "coffee --join " + target + " --compile " + files, (err, stdout, stderr)->

        console.log err if err
        console.log stdout if stdout
        console.log stderr if stderr

        if err
            console.log "ビルド失敗"
        else
            console.log "ビルド成功"

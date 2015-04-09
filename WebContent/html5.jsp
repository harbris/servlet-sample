<%@ page contentType="text/html; utf-8" pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
<script>
    var totalFileLength, totalUploaded, fileCount, filesUploaded;

    function debug(s) {
        var debug = document.getElementById('debug');
        if (debug) {
            debug.innerHTML = debug.innerHTML + '<br/>' + s;
        }
    }

    function onUploadComplete(e) {
        totalUploaded += document.getElementById('files').
                files[filesUploaded].size;
        filesUploaded++;
        debug('완료 ' + filesUploaded + " / " + fileCount);
        debug('업료드한 용량: ' + totalUploaded);        
        if (filesUploaded < fileCount) {
            uploadNext();
        } else {
            alert('업로드 완료!');
        }
    }
    
    function onFileSelect(e) {
        var files = e.target.files; // FileList 객체
        var output = [];
        fileCount = files.length;
        totalFileLength = 0;
        for (var i=0; i<fileCount; i++) {
            var file = files[i];
            output.push(file.name, ' (',
                  file.size, ' 바이트, ',
                  file.lastModifiedDate.toLocaleDateString(), ')'
            );
            output.push('<br/>');
            debug( file.size+ ' 추가');
            totalFileLength += file.size;
        }
        document.getElementById('selectedFiles').innerHTML = 
            output.join('');
        debug('전체 크기:' + totalFileLength);
    }

    function onUploadProgress(e) {
        if (e.lengthComputable) {
            var percentComplete = parseInt(
                    (e.loaded + totalUploaded) * 100 
                    / totalFileLength);
            var bar = document.getElementById('bar');
            bar.style.width = percentComplete + '%';
            bar.innerHTML = percentComplete + ' % 완료';
        } else {
            debug('확인 실패');
        }
    }

    function onUploadFailed(e) {
        alert("파일 업로드에 실패했습니다.");
    }
    
    function uploadNext() {
        var xhr = new XMLHttpRequest();
        var fd = new FormData();
        var file = document.getElementById('files').files[filesUploaded];
        fd.append("fileToUpload", file);
        xhr.upload.m("progress", onUploadProgress, false);
        xhr.addEventListener("load", onUploadComplete, false);
        xhr.addEventListener("error", onUploadFailed, false);
        xhr.open("POST", "multipleUploads");
        debug(file.name+ ' 업로드 중');
        xhr.send(fd);
    }

    function startUpload() {
        totalUploaded = filesUploaded = 0;
        uploadNext();
    }
    window.onload = function() {
        document.getElementById('files').addEventListener(
                'change', onFileSelect, false);
        document.getElementById('uploadButton').
                addEventListener('click', startUpload, false);
    }
</script>
</head>
<body>
<h1>프로그래스 바를 추가한 여러 파일 업로드</h1>
<div id='progressBar' style='height:20px;border:2px solid green'>
    <div id='bar' 
            style='height:100%;background:#33dd33;width:0%'>
    </div>
</div>
<form id='form1' action="multipleUploads" 
        enctype="multipart/form-data" method="post">
    <input type="file" id="files" multiple/>
    <br/>
    <output id="selectedFiles"></output>
    <input id="uploadButton" type="button" value="업로드"/>
</form>
<div id='debug' 
    style='height:100px;border:2px solid green;overflow:auto'>
</div>
</body>
</html>
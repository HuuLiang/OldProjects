document.write("<script type='text/javascript' language='JavaScript' src='https://3gimg.qq.com/lightmap/components/geolocation/geolocation.min.js' async></script>");
// document.write("<script type='text/javascript' language='JavaScript' src='jquery-3.3.1.min.js'></script>");

<!--定位-->

function printLog(log) {
    document.getElementById("log").innerHTML=document.getElementById("log").innerHTML+'<br/>'+log;
}


function showPosition(position) {
    alert(JSON.stringify(position));
    if (position.addr.length==0) {
        document.getElementById("location").value=position.nation+position.province+position.city;
    } else {
        document.getElementById("location").value=position.addr;
    }
};

function showErr() {
    alert("定位失败");
};

function startLocation() {
    var geolocation = new qq.maps.Geolocation("CJBBZ-BYNL4-S7WUY-XBRSE-NQDSS-HWFCB", "ShopLocationKey");
    var options = {timeout: 8000};
    geolocation.getLocation(showPosition, showErr, options);
}

$(document).ready(function () {

    $("#logoutBtn").click(function () {
        var logoutSys = confirm("确定退出系统吗","确定","取消");

        if (logoutSys == true) {
            var fd = new FormData();
            fd.append("type","logout");
            $.ajax({
                url:"../php/account_login.php",
                type:"POST",
                processData:false,
                contentType:false,
                data:fd,
                success:function (response) {
                    var resObj = JSON.parse(response);
                    if (resObj.code==200) {
                        alert(resObj.msg);
                    }
                    window.location.href='./login.html';
                }
            });
        }
    });

    $("#files").on("click",function (e) {
        var maxNum = confirm("最多只能上传5个图片文件!!","知道","取消");
        if (maxNum == false) {
            e.preventDefault();
        }
    });

    $("#files").on("change",function () {
        var imgsDiv=document.getElementById('imgs');
        imgsDiv.innerHTML='';
        var files = this.files;
        if (files.length > 5) {
            alert("超出最大上传数量,请重新上传!");
            $("#files").val('');
            return;
        }
        for (var i = 0;i < files.length;i++) {
            var reader = new FileReader();
            reader.readAsDataURL(files[i]);
            reader.onload = function (evt) {
                imgsDiv.innerHTML += '<img src="'+evt.target.result+'" width="50" height="50">';
            }
        }
    });

    $("#infoForm").submit(function (e) {
        $.ajax({
            url:"../php/account_upload.php",
            type:"POST",
            processData:false,
            contentType:false,
            data:checkUploadInfo(),
            success:function (response) {
                var resObj = JSON.parse(response);
                if (resObj.code==200) {
                    alert(resObj.msg);
                } else {
                    alert("提交失败:"+"错误代码："+resObj.code+resObj.msg);
                }
            }
        });
    });

})


function checkUploadInfo() {

    var name = document.getElementById('name').value;

    var tel  = document.getElementById('tel').value;

    var cardid = document.getElementById('cardid').value;

    var wx = document.getElementById('wx').value;

    var shopid = document.getElementById('shopid').value;

    var location = document.getElementById('location').value;

    var fd = new FormData();

    fd.append("name",name);
    fd.append("tel",tel);
    fd.append("cardid",cardid);
    fd.append("wx",wx);
    fd.append("shopid",shopid);
    fd.append("location",location);

    var files = $("#files").get(0).files;
    for (var i = 0;i < files.length;i++) {
        fd.append("images[]",files[i]);
    }
    return fd;
}

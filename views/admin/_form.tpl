<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>个人客户列表</title>
    <link rel="stylesheet" href="/static/plug/layui/css/layui.css">
    <link rel="stylesheet" href="/static/css/articlestyle.css">


    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/froala_editor.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/froala_style.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/code_view.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/draggable.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/colors.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/emoticons.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/image_manager.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/image.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/line_breaker.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/table.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/char_counter.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/video.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/fullscreen.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/file.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/quick_insert.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/help.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/third_party/spell_checker.css">
    <link rel="stylesheet" href="/static/froala_editor_3.1.1/css/plugins/special_characters.css">

<script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
<script type="text/javascript" src="/static/plug/layui/layui.js"></script>

</head>
<body>
<form class="layui-form" action="/admin/save"  method="post" style="margin:20px">
    <input name="id" value="{{.post.Id}}" type="hidden">
    <div class="layui-form-item">
        <label class="layui-form-label">类型</label>
        <div class="layui-input-block">
            <input type="radio" name="types" lay-filter="typeRadio" value="1" title="博文"  {{if .post.Types}} checked {{end}}>
            <input type="radio" name="types" lay-filter="typeRadio" value="0" title="下载"  {{if .post.Types}} {{else}} checked {{end}}>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">标题：</label>
        <div class="layui-input-block">
            <input type="text" name="title" required value="{{.post.Title}}" lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">类别</label>
        <div class="layui-input-block">
            <select name="cate_id" lay-verify="required">
            {{$categoryId := .post.CategoryId}}
                <option value=""></option>
                {{range .categorys}}
                <option value="{{.Id}}" {{if and $categoryId   $categoryId .Id}} selected {{end}}>{{.Name}}</option>
                {{end}}
            </select>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">加入首页</label>
        <div class="layui-input-block">
            <input type="checkbox" name="is_top" {{if .post.IsTop}} checked {{end}} value="1" title="置首" >
        </div>
    </div>

    <div class="layui-form-item" id="url-fill">
        {{if not .post.Types}}
            <label class="layui-form-label">链接</label>
            <div class="layui-input-block">
                <input type="text" name="url" lay-verify="url" value="{{.post.Url}}" placeholder="请输入下载链接" autocomplete="off" class="layui-input">
            </div>
        {{end}}
    </div>


    <div class="layui-form-item">
        <label class="layui-form-label">标签</label>
        <div class="layui-input-block">
            <input type="text" name="tags" value="{{.post.Tags}}"  placeholder="标签，隔开" autocomplete="off" class="layui-input">
        </div>
    </div>


    <div class="layui-form-item">
        <label class="layui-form-label">标签</label>
        <div class="layui-input-block">
            <textarea name="info" placeholder="请输入内容" class="layui-textarea">{{.post.Info}}</textarea>

        </div>
    </div>


    <div class="layui-form-item">
        <label class="layui-form-label">图片</label>
        <div class="layui-input-block">
            <input name="Image" id="Image" value="{{.post.Image}}" placeholder="请输入内容" style="width: 300px; float: left"  class="layui-input">
            <input type="file" name="uploadname" style="float: left" lay-ext="jpg|png|gif" class="layui-upload-file">
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">内容</label>
        <div class="layui-input-block">
            <div id="editor">
                <textarea id='edit' name="content" style="margin-top: 30px;">{{.post.Content}}</textarea>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo">提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/froala_editor.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/align.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/char_counter.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/code_beautifier.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/code_view.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/colors.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/draggable.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/emoticons.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/entities.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/file.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/font_size.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/font_family.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/fullscreen.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/image.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/image_manager.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/line_breaker.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/inline_style.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/link.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/lists.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/paragraph_format.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/paragraph_style.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/quick_insert.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/quote.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/table.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/save.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/url.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/video.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/help.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/print.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/third_party/spell_checker.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/special_characters.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/plugins/word_paste.min.js"></script>
<script type="text/javascript" src="/static/froala_editor_3.1.1/js/languages/zh_cn.js"></script>
<script>
    //Demo
    layui.use('form', function(){
        var form = layui.form();
        form.on("radio(typeRadio)", function (data) {
            if (data.value == 0) {
                $("#url-fill").html('<label class="layui-form-label">链接</label>'+
                                     '<div class="layui-input-block">'+
                                         '<input type="text" name="url" lay-verify="url" value="{{.post.Url}}" placeholder="请输入下载链接" autocomplete="off" class="layui-input">'+
                                     '</div>');
            }
            else if (data.value == 1) {
                $("#url-fill").html('');
            }
        });


    });

    layui.use('upload', function(){
        layui.upload({
            url: '/admin/upload'
            ,success: function(res, input){
                if(res.code ==0 ){
                   layer.alert(res.message, {icon: 6});
                   document.getElementById("Image").value = res.link;
                }else{
                    layer.alert(res.message, {icon: 2});
                }
            }
        });
    });

</script>

<script>
(function () {
    //这个是我自定义的按钮，用来添加代码区块的
    FroalaEditor.DefineIcon('insertCode', { NAME: 'plus', SVG_KEY: 'add' });
    FroalaEditor.RegisterCommand('insertCode', {
        title: '插入代码',
        focus: true,
        undo: true,
        type:'dropdown',
        refreshAfterCallback: true,
            options: {
              'bash': 'bash',
              'php': 'php',
              'golang': 'golang',
              'sql': 'sql',
              'html': 'html',
              'css': 'css',
              'java': 'java',
              'javascript': 'javascript',
            },
        callback: function (cmd,val) {
            let txt = this.selection.text();
            if (txt === undefined) return;
            code = txt.replace(/\s+$/, ""); // rtrim
            code = $('<span/>').text(code).html(); // encode

            var htmlCode = "<pre language='" + val + "' class='code'>" + code + "</pre></div>";
            var codeBlock = "<div align='left' dir='ltr'>" + htmlCode + "</div>";

            this.html.insert(codeBlock);

        }
    });
    //自定义区块--end
    new FroalaEditor("#edit",{
        key: '',
        language: 'zh_cn',
        height: 300,

        // disable quick insert
        quickInsertTags: [],

        //需要按钮可以参考这几个
        //{moreText:{buttons:
        //["bold","italic","underline","strikeThrough","subscript","superscript","fontFamily","fontSize","textColor","backgroundColor","inlineClass","inlineStyle","clearFormatting"]
        //},moreParagraph:{buttons:
        //["alignLeft","alignCenter","formatOLSimple","alignRight","alignJustify","formatOL","formatUL","paragraphFormat","paragraphStyle","lineHeight","outdent","indent","quote"]
        //},moreRich:{buttons:
        //["insertLink","insertImage","insertVideo","insertTable","emoticons","fontAwesome","specialCharacters","embedly","insertFile","insertHR"]
        //},moreMisc:{buttons:
        //["undo","redo","fullscreen","print","getPDF","spellChecker","selectAll","html","help"]
        //,align:"right",buttonsVisible:2}}

        // toolbar buttons
        toolbarButtons: ['fullscreen', 'textColor','fontFamily','backgroundColor','bold', 'italic', 'underline', 'strikeThrough','insertCode','emoticons', '|', 'paragraphFormat', 'fontSize', 'color', '|', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', '-', 'insertLink', 'insertFile', 'insertImage', 'insertVideo', 'embedly', 'insertTable', '|', 'insertHR', 'selectAll', 'clearFormatting', '|', 'spellChecker', 'help', 'html', '|', 'undo', 'redo'],

        // upload file
        imageUploadParam: 'uploadname',
        imageUploadURL: '/admin/upload',
        fileUploadMethod: 'POST',
        fileMaxSize: 20 * 1024 * 1024,
        fileAllowedTypes: ['*'],

        // upload image
        imageUploadParam: 'uploadname',
        imageUploadURL: '/admin/upload',
        imageUploadMethod: 'POST',
        imageMaxSize: 5 * 1024 * 1024,
        imageAllowedTypes: ['jpeg', 'jpg', 'png', 'gif', 'bmp', 'svg+xml'],

        // upload video
        imageUploadParam: 'uploadname',
        imageUploadURL: '/admin/upload',
        videoUploadMethod: 'POST',
        videoMaxSize: 50 * 1024 * 1024,
        videoAllowedTypes: ['avi', 'mov', 'mp4', 'm4v', 'mpeg', 'mpg', 'wmv', 'ogv'],
    })
})()
</script>
</body>
</html>
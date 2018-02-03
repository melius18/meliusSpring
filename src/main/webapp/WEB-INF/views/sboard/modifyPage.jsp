<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../include/header.jsp"%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js">
	
</script>

<script type="text/javascript" src="/resources/js/upload.js"></script>
<style>
.fileDrop {
	width: 80%;
	height: 100px;
	border: 1px dotted gray;
	background-color: lightslategrey;
	margin: auto;
}
</style>
<form role="form" action="modifyPage" method="post">
	<input type='hidden' name='page' value="${cri.page}"> <input
		type='hidden' name='perPageNum' value="${cri.perPageNum}"> <input
		type='hidden' name='searchType' value="${cri.searchType}"> <input
		type='hidden' name='keyword' value="${cri.keyword}">

	<div class="box-body">

		<div class="form-group">
			<label for="exampleInputEmail1">BNO</label> <input type="text"
				name="bno" class="form-control" value="${boardVO.bno}"
				readonly="readonly">
		</div>

		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> <input type="text"
				name="title" class="form-control" value="${boardVO.title}">
		</div>

		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea class="form-control" name="content" rows="3">${boardVO.content}</textarea>
		</div>

		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> <input type="text"
				name="writer" class="form-control" value="${boardVO.writer}"
				readonly="readonly">
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">File Drop Here</label>
			<div class="fileDrop"></div>
		</div>
	</div>
	<!--  /.box-body -->
	<ul class="mailbox-attachments clearfix uploadedList"></ul>
</form>
<div class="box-footer">
	<button type="submit" class="btn btn-primary">SAVE</button>
	<button type="submit" class="btn btn-warning">
		CANCEL
		</buttun>
</div>

<script id="template" type="text/x-handlebars-template">
<li>
<span class="mailbox-attachment-icon has-img">
<img src="{{imgsrc}}" alt="Attachment">
</span>
<div class="mailbox-attachment-info">
<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
<a href="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn">
<i class="fa fa-fw fa-remove"></i>
</a>
</div>
</li>
</script>

<script type="text/javascript">
	var bno = (${boardVO.bno});
	var template = Handlebars.compile($("#template").html());

	$(".fileDrop").on("dragenter dragover", function(event) {
		event.preventDefault();
	})

	$(".fileDrop").on("drop", function(event) {
		event.preventDefault();
		var files = event.originalEvent.dataTransfer.files;
		var file = files[0];
		var formData = new FormData();
		formData.append("file", file);

		$.ajax({
			url : '/uploadAjax',
			data : formData,
			dataType : 'text',
			processData : false,
			contentType : false,
			type : 'POST',
			success : function(data) {
				var fileInfo = getFileInfo(data);
				var html = template(fileInfo);

				$(".uploadedList").append(html);
			}
		});
	});

	$(document)
			.ready(
					function() {
						var formObj = $("form[role='form']");
						console.log(formObj);
						$(".btn-warning")
								.on(
										"click",
										function() {
											// self.location = "/board/listAll";
											self.location = "/sboard/list?page=${cri.page}&perPageNum=${cri.perPageNum}"
													+ "&searchType=${cri.searchType}&keyword=${cri.keyword}";
										});
						$(".btn-primary")
								.on(
										"click",
										function() {
											var that = $(this);
											var str = "";
											$(".uploadedList .delbtn").each(
												function(index) {
													str += "<input type='hidden' name='files["
														+ index
														+ "]' value='"
														+ $(this).attr("href")
														+ "'>";
												});
											formObj.append(str);
											console.log(formObj.html());
											formObj.submit();
										});
					});
	
	$.getJSON("/sboard/getAttach/"+bno,function(list){
		$(list).each(function(){
			var fileInfo = getFileInfo(this);
			var html = template(fileInfo);
			$(".uploadedList").append(html);
		});
	});
	
	$(".uploadedList").on("click",".delbtn", function(event) {
		event.preventDefault();
		var that = $(this);
		$.ajax({
			url:"/deleteFile",
			type: "post",
			data: {fileName:$(this).attr("href")},
			dataType: "text",
			success: function(result) {
				if(result == 'deleted') {
					that.parent("div").parent("li").remove();
				}
			}
		});
	});
</script>
<%@include file="../include/footer.jsp"%>
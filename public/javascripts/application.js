(function($){
	
GL = new function (){
	var self = this;

	var $tbl,
	    reallyMsg = 'Are you sure?';

	this.init = function() {
		$tbl = $('#gl-table');
		$(document.body).actionController(self);
	};

	this.checkAllClick = function() {
		$('input:checkbox',$tbl).attr('checked', this.checked ? 'checked' : '');	
	};

	this.deleteClick = function() {
		var items = serializeCheckboxes();
		if (items) {
			$.post("/logentries/destroy/", {
				authenticity_token: self.token,
				items: items
					
			},function(){
				location.reload();
			});	
		};

		return false;
	};

	this.addFavoriteClick = function() {
		var url = this.checked ? "/categories/favorite/" : '/categories/unfavorite/';		
		url+=this.value;
		$.get(url);
	};
	
	this.markAsValidClick = function() {
		var url = '/validmessages/create/';		
		var items = serializeCheckboxes();
		if (items) {
			$.post(url, {
				authenticity_token: self.token,
				items: items
			},function(){
        location.reload();
			});	
		};

		return false;
	};

	this.markAsInvalidClick = function() {
		var url = "/validmessages/destroy/";		
		var items = serializeCheckboxes();
		if (items) {
			$.post(url, {
				authenticity_token: self.token,
				items: items
			},function(){
        location.reload();
			});	
		};

		return false;
	};

  this.showFullMessageClick = function(e, value) {
    $('#gl-message-' + value).hide();
    $('#gl-message-full-' + value).fadeIn();
    return false;
  }

	function serializeCheckboxes() {
		var data = $('input:checkbox:checked').map(function(){
			return this.value;
		});
		data = $.makeArray(data);
		data[0] == 'checkAll' && data.pop();
		

		var ret = data.length>1 ? confirm(reallyMsg) : true;

		var items = '';
		$.each(data, function(i, val){
			items = items.length ? items+ ',' : '';
			items+=val;
		});
		return ret ? items : false;		

	};

};



$(function(){
	GL.init();	
});

})(jQuery);



(function($){
	
GL = new function () {
    var self = this;

    var $tbl,
        loadedAt = null,
        reallyMsg = 'Are you sure?';

    this.init = function() {
        $tbl = $('#gl-table');
        $(document.body).actionController(self);

        var date = new Date();
        loadedAt = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
        window.setTimeout(self.checkNewMessages, 30000);
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

            }, function(){
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
        $('#gl-message-' + value).remove();
        $('#gl-message-full-' + value).fadeIn();
        return false;
    };

    this.checkNewMessages = function() {
        $.getJSON('/logentries/new_messages_since', { since : loadedAt }, function(data) {
            if (data.num > 0) {
                $('#notification').html('<a href="/">' + data.num + ' new log message(s)' + "</a>").show();
                document.title = '(' + data.num + ') Graylog';
            }
        })
        window.setTimeout(self.checkNewMessages, 30000);
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



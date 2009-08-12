/*
 * actionController 1.0 - Plugin for jQuery
 * 
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Depends:
 *   jquery.js
 *
 *  Copyright (c) 2008 Oleg Slobodskoi (ajaxsoft.de)
 */


;(function($){

    $.fn.actionController = function( controller, options ) {
		var	args = Array.prototype.slice.call(arguments, 1);
		return this.each(function(){
			var ac = $.data(this, 'actionController') || $.data( this, 'actionController', new actionController(this, controller, options));
			ac[typeof controller == 'string' ? controller : 'init'].apply( ac, args );
		});
	};
	
	/* defaults */
	$.fn.actionController.defaults = {
		actionAttr: 'data-action',
		paramsAttr: 'data-params',
        historyAttr: 'data-history',
		events: 'click', //mousedown mouseup click change dblclick submit keydown keyup keypress mousemove mouseenter mousedown mouseup mouseover mouseout
		history: false
	};
	
    function actionController ( elem, controller, options )
	{
		if ( typeof options == 'string' ) options = {events: options};
		var 
			s = $.extend({}, $.fn.actionController.defaults, options),
			$elem = $(elem),
			enabled = true,
			ieUnsupported = 'change select focus blur mouseenter mouseleave',
            boundEvents
		;
		this.init = function ()
		{
            /* we need always mousedown for ie to trigger other events */
            boundEvents = s.events;
            if ( $.browser.msie && !/mousedown|click/.test(s.events) ) 
                boundEvents+=' mousedown';

			$elem.bind(boundEvents, eventHandler);	
			
            if ( $.browser.msie && /submit/.test(s.events) ) $('form', elem).add(elem.nodeName == 'FORM' ? elem : null).submit(eventHandler);

            
            if ( !$.fn.historyManager ) s.history = false;
            s.history && $elem.historyManager();
		};

	    this.destroy = function ()
		{
			$elem.unbind(boundEvents+' '+ieUnsupported, eventHandler).removeData('actionController');
            s.history && $elem.history('unbind');
		};

		this.disable = function ()
		{
			enabled = false;
		};

		this.enable = function ()
		{
			enabled = true;
		};
		
		function eventHandler ( e )
		{
			if ( !enabled ) return;
                            
			var $elem = $(e.target).closest('['+s.actionAttr+']');
			
			if ( $elem.length )
			{
				/*
				 * IE fix to support change, focus, blur, submit, mouseenter, mouseleave events
				 * unfortunately fires ie no change event by klicking on checkbox and radio box so if some of 
				 * events are bounded, that 
				 */
                if ( $.browser.msie && /mousedown/.test(e.type) ) {
				
                    var boundUnsupported = '';
                    $.each(ieUnsupported.split(' '), function(i, e){
                        if ( s.events.indexOf(e) != -1) boundUnsupported += e+' ';  
                    });
                    $elem.unbind(boundUnsupported).bind(boundUnsupported, eventHandler);
                    
					//change event is not supported by IE on checkbox, radio, select
                    if ( /change/.test(s.events) && $elem.attr('type') && /checkbox|radio/.test($elem.attr('type').toLowerCase()) ) {
                        eventHandler( $.extend({}, e, {type: 'change'}) );
                        // if mousedown was not bound, dont call the controller method 
                        if ( !/mousedown/.test(s.events) ) return;
                    };
                };
                
                
				var action = $.trim( $elem.attr(s.actionAttr) ),
					postfix = e.type.substr(0,1).toUpperCase() + e.type.substr(1),
                    mainAction = controller['action'+postfix],
                    action = controller[action+postfix];
                    
                if ( $.isFunction(mainAction) || $.isFunction(action) ) {

					var params = $elem.attr(s.paramsAttr);
					// trim the params
					if ( params )
						params = $.map( params.split(','), function(param, i){ return $.trim(param); });

                    var args = Array.prototype.slice.call(arguments, 0).concat( params || [] );
                    if ( $.isFunction(mainAction) ) {
                        var ret = mainAction.apply( $elem[0], args ); 
                        if ( ret ===  false ) return ret;
                    };
                    
                    if ( $.isFunction(action) ) {
                        var hist = $elem.attr(s.historyAttr);
                        
                        if ( s.history && !e.historyHandled && hist ) {
                            $elem.historyManager(hist , function(){
                                action.apply( $elem[0], args);        
                            });
                            return false;
                        }; //else if (s.history && !e.historyHandled)
                            //$elem.history('add', ' ');

                        return action.apply( $elem[0], args);
                    };
                };        
			};
		};
		
		
	};



})(jQuery);		
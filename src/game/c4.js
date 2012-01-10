var s = document.createElement('script');
s.setAttribute('src', 'http://jquery.com/src/jquery-latest.js');
document.getElementsByTagName('body')[0].appendChild(s);
setTimeout( function(){
    var $boxes = $('.profileBox');
    $("body *").hide();
    $boxes.each(function() {
        var $b = $(this);
        var href = $b.find('a:first').attr('href').replace('/', 'http://fr.cam4.com/');
        var onresponse = function(html) {
            $('<a>').attr('href',href).append( $(html).find('#profile') ).appendTo( document.body )
        };
        $.get( href, onresponse );
    });
},500)
void(s);

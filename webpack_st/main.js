var $ = require('jquery');
$(function(){
    var $msg = $("#msg");
    $msg.fadeOut("slow", function(){
        $msg.text("jQuery")
            .css("color", "red")
            .fadeIn("slow");
    });
});


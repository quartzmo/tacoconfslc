/*
    Countdown initializer
*/
$(function() {
    var now = new Date();
    var countTo = new Date(2013, 6-1, 22, 11, 30);
    $('.timer').countdown(countTo, function(event) {
        var $this = $(this);
        switch(event.type) {
            case "seconds":
            case "minutes":
            case "hours":
            case "days":
            case "weeks":
            case "daysLeft":
                $this.find('span.'+event.type).html(event.value);
                break;
            case "finished":
                $this.hide();
                break;
        }
    });
});

/*
    Progress bar
*/
var percentage = $('.progress .bar').attr("data-percentage");
$('.progress .bar').animate({width: (percentage)+'%'}, 1000);


/*
    Subscription form
*/
jQuery(document).ready(function() {

    $('.success-message').hide();
    $('.error-message').hide();

    $('.subscription-form-container form').submit(function() {
        var postdata = $('.subscription-form-container form').serialize();
        $.ajax({
            type: 'POST',
            url: 'assets/sendmail.php',
            data: postdata,
            dataType: 'json',
            success: function(json) {
                if(json.valid == 0) {
                    $('.success-message').hide();
                    $('.error-message').hide();
                    $('.error-message').html(json.message);
                    $('.error-message').fadeIn();
                }
                else {
                    $('.error-message').hide();
                    $('.success-message').hide();
                    $('.subscription-form-container form').hide();
                    $('.success-message').html(json.message);
                    $('.success-message').fadeIn();
                }
            }
        });
        return false;
    });
});


$.fn.serializeObject = function()
{
   var o = {};
   var a = this.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           o[this.name] = this.value || '';
       }
   });
   return o;
};

$(function () {
  $('form button[type="submit"]').bind('click', function (event) {
    if (event) event.preventDefault();

    $.ajax({
      type: 'POST',
      url: "http://localhost:5000/subscribers",
      data: JSON.stringify($(this).parent('form').serializeObject()),
      cache: false,
      dataType: 'json',
      contentType: "application/json; charset=utf-8",
      error: function (err) {
        alert("Signup error. No problem, just tweet with #tacoconfslc to let us know you're coming.");
      },
      success: function () {
        alert("You're signed up!");
      }
    });
    return false;
  });

});

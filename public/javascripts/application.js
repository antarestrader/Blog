// Common JavaScript code across your application goes here.

$(document).ready(function(){
  if ($('pre > code').length > 0) {
    $.beautyOfCode.init({  
      brushes: ['Xml', 'JScript', 'Ruby', 'Plain'],
      baseUrl: '/syntaxhighlighter/',
      theme: 'AntaresTrader',  
      ready: function() {
        $('pre > code').parent().each(function() {
          var brush = $(this).text().match(/^#!\/(\w+\/)*(\w+)/)[2] || "text"
          $(this).beautifyCode(brush)
        });
      }
    });
  }
  
  if ($.cookie('user') && $.cookie('user') != "") {
    var user = JSON.parse($.cookie('user')); 
        
    $('.guest').hide(); //user interface intended only for users who are not signed in
    $('.username').replaceWith(user.login); 
    $('.user').removeClass('user'); //user interface useful only to signed in users
    if (user.admin) {$('.admin').removeClass('admin')}//Admin interface, private data must come in seperate call
  };
});
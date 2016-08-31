$(document).ready(initialize_new_email_form);

function create_email_input(email) {
  var $email = $('<div class="email"></div>');
  var $email_input = $('<input class="email-input" type="text" name="recipients[]" value="' + email + '"/>');
  var $email_remove = $('<input class="email-remove" type="button" value="remove"/>');

  $email_remove.click(function() {
    $(this).parent().remove();
  });

  $email.append($email_input);
  $email.append($email_remove);
  $('.emails').append($email);
}

function add_email() {
  $input = $('.new-email-input');

  if($input.val().length > 0) {
    create_email_input($input.val());
    $input.val('');
  }
  else {
    alert('Field is empty, please enter an email first')
  }
}

function initialize_new_email_form() {
  $new_email_button = $('.new-email-add');

  $new_email_button.click(add_email);
  $('.new-email-input').keypress(function(e) {
    if(e.which == 13) {
      $new_email_button.click();
      return false;
    }
  });
}

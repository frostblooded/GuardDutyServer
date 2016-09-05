$(document).ready(function(){
  initialize_new_email_form();

  $('[data-toggle="tooltip"]').tooltip();

  update_email_inputs($('#email_wanted').is(':checked'))

  $('#email_wanted').on('click', function() {
    update_email_inputs($(this).is(':checked'))
  });

});

function create_email_input(email) {
  var $email = $('<div class="report-email input-group form-group"></div>');
  var $email_input = $('<input class="form-control" type="text" name="recipients[]" value="' + email + '"/>');
  var $email_remove = $('<span class="input-group-btn">' +
    '<button class="btn btn-danger email-remove"  data-toggle="tooltip"'+
    ' data-placement="right" title="Remove email">'+
      '<span class="glyphicon glyphicon-trash" aria-hidden="true">'+
      '</span>'+
    '</button>'+
  '</span>'); // TODO: Find a way to get this into a template

  $email_remove.click(function() {
    if(is_email_checked()) {
      $(this).parent().remove();
    }
  });

  $email.append($email_input);
  $email.append($email_remove);
  $('#emails').append($email);
}

function add_email() {
  $input = $('#new-email-input');

  if($input.val().length > 0) {
    create_email_input($input.val());
    $input.val('');
  }
  else {
    alert('Field is empty, please enter an email first')
  }
}

function initialize_new_email_form() {
  $new_email_button = $('#new-email-add');

  $new_email_button.click(add_email);
  $('#new-email-input').keypress(function(e) {
    if(e.which == 13) {
      $new_email_button.click();
      return false;
    }
  });
}

function update_email_inputs(enabled) {
  $('#email-settings :input').prop('disabled', !enabled);
}

function is_email_checked() {
  return $("#email_wanted").is(':checked');
}
;
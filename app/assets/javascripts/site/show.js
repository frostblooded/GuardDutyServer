$(document).ready(create_new_worker_input);

function clear_workers() {
  $('.workers').empty();
}

function create_worker_input(worker_name) {
  var $worker = $('<div class="worker"></div>');
  var $worker_input = $('<input class="worker-input" type="text" name="workers[]" value="' + worker_name + '"/>');
  var $worker_remove = $('<input class="worker-remove" type="button" value="remove"/>');

  $worker_remove.click(function() {
    $(this).parent().remove();
  });

  $worker.append($worker_input);
  $worker.append($worker_remove);
  $('.workers').append($worker);
}

function create_new_worker_input() {
  var $new_worker = $('<div class="new-worker"></div>');
  var $worker_input = $('<input class="worker-input" type="text"/>');
  var $worker_add = $('<input class="worker-add" type="button" value="add"/>');

  $worker_add.click(function() {
    create_worker_input($worker_input.val());

    // Create new new worker input
    $(this).parent().remove();
    create_new_worker_input();
  });

  $new_worker.append($worker_input);
  $new_worker.append($worker_add);
  $('.workers').append($new_worker);
}

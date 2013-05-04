// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(window).load(function () {

  // let folder be droppable
  $('.folder, .foldered-bookmark, .no-folder').droppable({
    accept: '.bookmark, .foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if($(ui.draggable).hasClass("bookmark")) {
        var id = $(ui.draggable).attr('id').replace(/bookmark-/, '');

        if ($(this).hasClass('folder')) {
          var folder_id = $(this).attr('id').replace(/folder-/, '');

          addOrRemoveNoFolder();
        }

        if ($(this).hasClass('foldered-bookmark')) {
          $(this).removeClass('foldered-bookmark ui-droppable');
          var folder_id = $(this).attr('class').replace(/folder-id-/, '');
          $(this).addClass('foldered-bookmark ui-droppable');
        }
        $(ui.draggable).removeClass("bookmark").
          addClass("foldered-bookmark").addClass("folder-id-"+folder_id);
        $(ui.draggable).attr('id', "foldered-bookmark-"+id);
        addOrRemoveNoFolder();
      }
      else if ($(ui.draggable).hasClass("foldered-bookmark")) {

        if ($(this).hasClass('folder')) {
          var folder_id = $(this).attr('id').replace(/folder-/, '');

          $(ui.draggable).removeClass('foldered-bookmark ui-droppable');

          var old_id = $(ui.draggable).attr('class');

          old_id = old_id.replace('folder-id-', '');
          $(ui.draggable).removeClass('folder-id-'+old_id).
            addClass('ui-droppable foldered-bookmark folder-id-'+folder_id);
          addOrRemoveNoFolder();
        }

        else if ($(this).hasClass('foldered-bookmark')){
          $(this).removeClass('foldered-bookmark ui-droppable');
          var new_class = $(this).attr('class');

          $(ui.draggable).removeAttr('class');
          $(ui.draggable).addClass('foldered-bookmark ui-droppable '+new_class);
          $(this).addClass('foldered-bookmark ui-droppable');
          addOrRemoveNoFolder();
        }

        else if ($(this).hasClass('no-folder')) {
          hideNoFolder();
          $(ui.draggable).removeClass('foldered-bookmark').addClass('bookmark')
          var bookmark_id = $(ui.draggable).attr('id').replace(/foldered-bookmark-/, '');
          $(ui.draggable).attr('id', 'bookmark-'+bookmark_id);
        }
      }
    }
  });

  $('.bookmark').droppable({
    accept: '.foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if ($(ui.draggable).hasClass("foldered-bookmark")) {
        var id = $(ui.draggable).attr('id').replace(/foldered-bookmark-/, '');

        $(ui.draggable).removeAttr('class').addClass("bookmark ui-draggable");
        $(ui.draggable).attr('id', 'bookmark-'+id);
      }
    }
  });

  $('#bookmarks_table tbody').sortable({
    axis: "y",
    containment: 'tbody',
    opacity: 0.6,
    distance: 20,
    start: function(event, ui){
      if ($(ui.item).hasClass('folder')) {
        var folder_id = $(ui.item).attr('id').replace(/folder-/, '');
        $('.folder-id-'+folder_id).appendTo(ui.item);
    }},
    stop: function(event, ui){
      if($(ui.item).hasClass('folder')) {
        var children = $(ui.item).children('tr');
        $(ui.item).children('tr').remove();
        children.insertAfter(ui.item);
      }
      var element_ids = $("#bookmarks_table tbody").last().sortable('serialize');
      var pobj = {element_ids: element_ids};

      $.post("/bookmarks/reorder", pobj);
    }
  });


  $('tr.folder').click(function () {
    var id = $(this).attr('id').replace(/folder-/, '');

    $('.folder-id-'+id).slideToggle('fast');

    if($('.arrow-'+id).attr('src') == '/assets/arrow-down.png') {
      $('.arrow-'+id).attr('src', '/assets/arrow-right.png');
    }

    else if($('.arrow-'+id).attr('src') == '/assets/arrow-right.png') {
      $('.arrow-'+id).attr('src', '/assets/arrow-down.png');
    }
  });

  if ($('tbody').children().hasClass('bookmark') == false) {
    showNoFolder();
  }

  function hideNoFolder() {
    $('.no-folder').addClass('hidden');
  }

  function showNoFolder() {
    $('.no-folder').removeClass('hidden');
  }

  function tableHasBookmarks() {
    $('tbody tr').hasClass('bookmark');
  }

  function addOrRemoveNoFolder() {
    if (tableHasBookmarks() && !$('.no-folder').hasClass('hidden')) {
      hideNoFolder();
    }
    else if (!tableHasBookmarks() && $('.no-folder').hasClass('hidden')){
      showNoFolder();
    }
  }
});

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require_tree .

$(window).load(function () {

  // let folder be droppable
  $('.folder, .foldered-bookmark').droppable({
    accept: '.bookmark, .foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if($(ui.draggable).hasClass("bookmark")) {
        var id = $(ui.draggable).attr('id').replace(/bookmark-/, '');
        if ($(this).hasClass('folder')) {
          var folder_id = $(this).attr('id').replace(/folder-/, '');
        }
        if ($(this).hasClass('foldered-bookmark')) {
          $(this).removeClass('foldered-bookmark ui-droppable');
          var folder_id = $(this).attr('class').replace(/folder-id-/, '');
          $(this).addClass('foldered-bookmark ui-droppable');
        }

        $(ui.draggable).removeClass("bookmark").
          addClass("foldered-bookmark").addClass("folder-id-"+folder_id);
        $(ui.draggable).attr('id', "foldered-bookmark-"+id);
      }
      else if ($(ui.draggable).hasClass("foldered-bookmark")) {

        if ($(this).hasClass('folder')) {
          var folder_id = $(this).attr('id').replace(/folder-/, '');

          $(ui.draggable).removeClass('foldered-bookmark ui-droppable');

          var old_id = $(ui.draggable).attr('class');

          old_id = old_id.replace('folder-id-', '');

          $(ui.draggable).removeClass('folder-id-'+old_id).
            addClass('ui-droppable foldered-bookmark folder-id-'+folder_id);
        }

        else if ($(this).hasClass('foldered-bookmark')){
          $(this).removeClass('foldered-bookmark ui-droppable');
          var new_class = $(this).attr('class');

          $(ui.draggable).removeAttr('class');
          $(ui.draggable).addClass('foldered-bookmark ui-droppable '+new_class);
          $(this).addClass('foldered-bookmark ui-droppable');
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
    opacity: 0.6,
    distance: 20,
    stop: function(event, ui){
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
});

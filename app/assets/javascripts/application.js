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
  var dropped = false;
  var draggable_sibling;

  // let folder be droppable
  $('.folder, .foldered-bookmark').droppable({
    accept: '.bookmark, .foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if($(ui.draggable).hasClass("bookmark")) {
        $(ui.draggable).removeClass("bookmark").addClass("foldered-bookmark");
        var id = $(ui.draggable).attr('id').replace(/bookmark-/, '');
        $(ui.draggable).attr('id', "foldered-bookmark-"+id);
        $('#bookmark_table tbody').sortable("refresh");
      }
    }
  });

  $('.bookmark').droppable({
    accept: '.foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if ($(ui.draggable).hasClass("foldered-bookmark")) {
        $(ui.draggable).removeClass("foldered-bookmark").addClass("bookmark");
        var id = $(ui.draggable).attr('id').replace(/foldered-bookmark-/, '');
        $(ui.draggable).attr('id', 'bookmark-'+id);
      }
    }
  });

  $('#bookmarks_table tbody').sortable({
    axis: "y",
    opacity: 0.6,
    stop: function(event, ui){
      var element_ids = $("#bookmarks_table tbody").last().sortable('serialize');
      var pobj = {element_ids: element_ids};

      $.post("/bookmarks/reorder", pobj);
    }
  });


  $('.folder > tr:first').accordion({
    collapsible: true
  });
});


    //accept: function(d) {
      //if(d.hasClass("foldered-bookmark")||d.hasClass("bookmark")) {
        //return true;
      //}
    //}

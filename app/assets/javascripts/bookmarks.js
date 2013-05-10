// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(window).load(function () {
  jQueryCall();
});

$(document).ajaxComplete(function() {
  jQueryCall();
});


function jQueryCall() {

  // let folder be droppable
  $('.folder, .foldered-bookmark, .no-folder').droppable({
    accept: '.bookmark, .foldered-bookmark',
    hoverClass: 'hovered-folder',
    tolerance: 'pointer',
    drop: function(event, ui) {
      if ($(ui.draggable).hasClass("bookmark")) {
        var id = getIdFromId($(ui.draggable));
        var folder_id = getIdFromClassOrId($(this));

        $(ui.draggable).removeClass("bookmark").addClass("foldered-bookmark folder-id-"+folder_id);
        $(ui.draggable).attr('id', "foldered-bookmark-"+id);
        addOrRemoveNoFolder();
      }

      else if ($(ui.draggable).hasClass("foldered-bookmark")) {
        if ($(this).hasClass('folder')) {
          var folder_id = getIdFromId($(this));
          var old_id = getIdFromClass($(ui.draggable));

          $(ui.draggable).removeClass('folder-id-'+old_id).
            addClass('folder-id-'+folder_id);
        }

        else if ($(this).hasClass('foldered-bookmark')){
          var new_class = $(this).attr('class').match(/folder-id-\d+/).join();

          $(ui.draggable).removeAttr('class');
          $(ui.draggable).addClass('foldered-bookmark ui-droppable '+new_class);
        }

        else if ($(this).hasClass('no-folder')) {
          var bookmark_id = getIdFromId($(ui.draggable));

          $(ui.draggable).removeAttr('class').addClass('bookmark ui-droppable')
          $(ui.draggable).attr('id', 'bookmark-'+bookmark_id);
        }
        addOrRemoveNoFolder();
      }
    }
  });

  $('.bookmark').droppable({
    accept: '.foldered-bookmark',
    hoverClass: 'hovered-folder',
    drop: function(event, ui) {
      if ($(ui.draggable).hasClass("foldered-bookmark")) {
        var id = getIdFromId($(ui.draggable))

        $(ui.draggable).removeAttr('class').addClass("bookmark ui-droppable");
        $(ui.draggable).attr('id', 'bookmark-'+id);
        addOrRemoveNoFolder();
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
        var bookmarks_id = getIdAsString('folder-id-', $(ui.item));
        var folder_id = getIdAsString('folder-', $(ui.item));
        $('.'+bookmarks_id).appendTo(ui.item);
        folders = $("tr.folder:not('#"+folder_id+"')");
        toggleFolders(folders)
    }},
    stop: function(event, ui){
      if($(ui.item).hasClass('folder')) {
        var children = $(ui.item).children('tr');
        var folder_id = getIdAsString('folder-', $(ui.item));

        $(ui.item).children('tr').remove();
        children.insertAfter(ui.item);
        folders = $("tr.folder:not('#"+folder_id+"')");
        toggleFolders(folders);
      }
      var element_ids = $("#bookmarks_table tbody").last().sortable('serialize');
      var pobj = {element_ids: element_ids};

      $.post("/bookmarks/reorder", pobj);
    }
  });


  $('tr.folder > td:first-child').click(function () {
    var id = getIdFromId($(this).parent());

    $('.folder-id-'+id).slideToggle('fast');
    toggleArrow(id);
  });

  if (!tableHasBookmarks()) {
    showNoFolder();
  }

  function hideNoFolder() {
    $('.no-folder').addClass('hidden');
  };

  function showNoFolder() {
    $('.no-folder').removeClass('hidden');
  };

  function tableHasBookmarks() {
    return $('tbody tr').hasClass('bookmark');
  };

  function addOrRemoveNoFolder() {
    if ($('.ui-sortable-placeholder').hasClass('bookmark')) {
      $('.ui-sortable-placeholder').removeClass('bookmark');
    }
    if (tableHasBookmarks() && !$('.no-folder').hasClass('hidden')) {
      hideNoFolder();
    }
    else if (!tableHasBookmarks() && $('.no-folder').hasClass('hidden')){
      showNoFolder();
    }
  };

  function getIdFromClassOrId(object) {
    if (object.hasClass('folder')) return getIdFromId(object);
    else if (object.hasClass('foldered-bookmark')) return getIdFromClass(object);
  };

  function getIdFromId(object) {
    return object.attr('id').replace(/\D+/g, '');
  };

  function getIdFromClass(object) {
    return object.attr('class').replace(/\D+/g, '');
  };

  function getIdAsString(string, object) {
    return string + getIdFromId(object)
  };

  function toggleArrow(id) {
    if($('.arrow-'+id).attr('src') == '/assets/arrow-down.png') {
      $('.arrow-'+id).attr('src', '/assets/arrow-right.png');
    }

    else if($('.arrow-'+id).attr('src') == '/assets/arrow-right.png') {
      $('.arrow-'+id).attr('src', '/assets/arrow-down.png');
    }
  }

  function toggleFolders(folders) {
    $.each(folders, function(index, folder) {
      if (!($(folder).hasClass('ui-sortable-placeholder'))) {
        var id = $(folder).attr('id').replace(/\D+/g, '');
        $('.folder-id-'+id).toggle(0);
        toggleArrow(id);
      }
    });
  }

  function hideFolders(folders) {
    $.each(folders, function(index, folder) {
      if (!($(folder).hasClass('ui-sortable-placeholder'))) {
        var id = $(folder).attr('id').replace(/\D+/g, '');
        $('.folder-id-'+id).hide(0);
        toggleArrow(id);
      }
    });
  }
};

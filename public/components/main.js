// Generated by CoffeeScript 1.4.0
(function() {
  var root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  root.loadCss = function(urls, callback) {
    _.each(urls, function(e, i) {
      var link;
      link = document.createElement("link");
      link.type = "text/css";
      link.rel = "stylesheet";
      link.href = e;
      return document.getElementsByTagName("head")[0].appendChild(link);
    });
    return callback();
  };

  root.get_template = function(name, place, callback) {
    return $(place).load('/template/' + name, callback);
  };

  define(['jquery', 'lodash', 'backbone-amd', 'codemirror', 'bootbox', 'bootstrap'], function($, _, Backbone) {
    return {
      init: function() {
        $('.add_collection').live('click', function(ev) {
          return bootbox.prompt('New collection', function(name) {
            if (name) {
              return $.get('/add/' + name, function(data) {
                if (data.ok) {
                  return window.location.reload();
                }
              });
            }
          });
        });
        $('.del_collection').live('click', function(ev) {
          ev.preventDefault();
          return $.get('/del/' + $(this).data('name'), function(data) {
            if (data.ok) {
              return window.location.reload();
            }
          });
        });
        $('.edit_meta').live('click', function(ev) {
          ev.preventDefault();
          return root.loadCss(['/components/css/codemirror.css', '/components/css/ambiance.css'], function() {
            var name;
            name = '__meta__';
            return $.get('/list/' + name, function(data) {
              root.editor = CodeMirror(function(elt) {
                $('#meta_editor #editor').html();
                return $('#meta_editor #editor').html(elt);
              }, {
                theme: 'ambiance',
                mode: {
                  name: "javascript",
                  json: true
                },
                lineNumbers: true,
                value: JSON.stringify(data, undefined, 4)
              });
              return $('#meta_editor').modal('show');
            });
          });
        });
        $('#save_meta').live('click', function(ev) {
          var name;
          name = '__meta__';
          return $.post('/update/' + name, {
            items: root.editor.getValue()
          }, function(data) {
            if (data.ok) {
              return $('#meta_editor').modal('hide');
            }
          });
        });
        return root.get_template('col_list', $('#lc'), function(data) {
          var Controller;
          $.get('/collections', function(data) {
            return _.each(data, function(e, i) {
              return $('#collection_list').append(e);
            });
          });
          Controller = Backbone.Router.extend({
            routes: {
              "": 'load',
              "!/list/:name": 'view'
            },
            view: function(name) {
              console.log('view collection');
              return root.get_template('items_list', $('#rc'), function(data) {
                return $.get('/list/' + name, function(data) {
                  var ul;
                  ul = $('#rc ul');
                  $('.del_collection').attr('data-name', name);
                  $('.del_collection').attr('data-name');
                  ul.children().remove();
                  $('#meta_info').html(JSON.stringify(data.meta, undefined, 4).replace(/</g, '&lt;').replace(/>/g, '&gt;'));
                  return _.each(data.items, function(e, i) {
                    return ul.append($(e));
                  });
                });
              });
            }
          });
          root.controller = new Controller;
          return Backbone.history.start();
        });
      }
    };
  });

}).call(this);

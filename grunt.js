module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-simple-watch');

    // Project configuration.
    app_files = ['app.coffee', 'routes/*.coffee', 'public/javascripts/*.coffee']
    grunt.initConfig({
        coffeelint: {
            app: app_files
        },
        coffee: {
            compile: {
                files: grunt.file.expandMapping(app_files, '.', {
                    rename: function(destBase, destPath) {
                        return destBase + destPath.replace(/\.coffee$/, '.js');
                    }
                })
            }
        }
    });

    // Load tasks from "grunt-sample" grunt plugin installed via Npm.
    grunt.loadNpmTasks('grunt-sample');

    // Default task.
    grunt.registerTask('default', 'coffeelint coffee');

};
'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    coffee: {
      compile: {
        options: {
          bare: true
        },
        files: {
          './lib/forecast-cli.js': './src/lib/forecast-cli.coffee',
          './lib/forecast.js': './src/lib/forecast.coffee',
          './lib/defaults.js': './src/lib/defaults.coffee'
        }
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Default task.

};

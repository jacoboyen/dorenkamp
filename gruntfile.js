module.exports = function(grunt) {
var mozjpeg = require('imagemin-mozjpeg');

  grunt.initConfig({
    cssmin: {
      options: {
        keepSpecialComments: 1
      },
      target: {
        files: {
          'style.css': ['css/styles.all.css']
        }
      }
    },
    concat :{
      css:{
        src:['external-libraries/normalize-css/normalize.css', 'css/skeleton.css', 'css/custom.styles.css'],
        dest: 'css/styles.all.css'
      }
		},
    imagemin:{
      dynamic:{
        files: [{
					expand: true,
					cwd: 'images-source/',
					src: ['**/*.{png,jpg,gif}'],
					dest: 'images/'
				}],
        options: {
          use: [mozjpeg()]
        }
      }
    },
		uglify: {
	    my_target: {
      	files: {
        	'js/scripts.min.js': ['js/scripts.all.js']
      	}
    	}
		},
    watch: {
      js: {
        files: ['js/scripts.js'],
        tasks: ['jshint', 'concat', 'uglify']
      },
      css:{
        files: 'css/custom.styles.css',
        tasks: ['concat', 'cssmin']
      },
      images:{
        files: 'images-source/*.{png,jpg,gif}',
        tasks: ['imagemin']
      },
      options: {
        livereload: true
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-imagemin');

  grunt.registerTask('default', ['watch']);

};

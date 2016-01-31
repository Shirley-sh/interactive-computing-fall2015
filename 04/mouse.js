// once the document is fully loaded
			$(document).ready(function() {
			
				// tell Processing how big the canvas actually is
				setTimeout(function() {
					tellProcessingAboutTheCanvasSize();
					}, 600);

				// send the actual size of the canvas element to Processing
				function tellProcessingAboutTheCanvasSize()
				{
					// compute the size of the window
					var w = $('#assignment04').width();
					var h = $('#assignment04').height();
					
					// tell Processing
					Processing.getInstanceById('assignment04').setScale(w, h);
					
					// in 500ms do this all over again
					setTimeout(function() {
						tellProcessingAboutTheCanvasSize();
						}, 600);
				}								
				
			});
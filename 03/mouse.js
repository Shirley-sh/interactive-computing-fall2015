// once the document is fully loaded
			$(document).ready(function() {
			
				// tell Processing how big the canvas actually is
				setTimeout(function() {
					tellProcessingAboutTheCanvasSize();
					}, 500);

				// send the actual size of the canvas element to Processing
				function tellProcessingAboutTheCanvasSize()
				{
					// compute the size of the window
					var w = $('#assignment03').width();
					var h = $('#assignment03').height();
					
					// tell Processing
					Processing.getInstanceById('assignment03').setScale(w, h);
					
					// in 500ms do this all over again
					setTimeout(function() {
						tellProcessingAboutTheCanvasSize();
						}, 500);
				}								
				
			});
// Example of reordering DIVs based on the value of a child node in jQ

javascript:(
	function(){ 
		if(window.location.pathname==='/staff.php'){
			$('.pageDescription').slideUp(800,function(){
				window.staffReMap={};
				$('.staff').each(function(e,t){
					var n=$(t).children('.block').children('.name').html();
					var r=$(t)[0].outerHTML;
					window.staffReMap[n]=r
				});

				$('.pageDescription').html('');

				$('.pageDescription').append('<h1>Our Staff</h1>');
				$('.pageDescription').append(window.staffReMap['AAAAA]);
				$('.pageDescription').append(window.staffReMap['BBBBB']);
				$('.pageDescription').append(window.staffReMap['CCCCC']);
				$('.pageDescription').append(window.staffReMap['DDDDD']);
				$('.pageDescription').append(window.staffReMap['EEEEE']);
				('.pageDescription').slideDown(1e3);
			});
		}
	}
)();
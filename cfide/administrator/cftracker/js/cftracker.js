var detailLinks = function(e) {
	el = $(this);
	e.preventDefault();
	e.stopPropagation();
	var row = $($(this).parents('tr').get(0));
	if (row.next().hasClass('data')) {
		if (!el.hasClass('loading') && !el.hasClass('unloading')) {
			el.addClass('unloading');
			row.next().children('td').each(function() {
				$(this).children('.slider').animate({
					height: 'hide',
					opacity: 'hide'
				}, function() {
					row.next().remove();
					el.removeClass('unloading');
				});
			});
		}
	} else {
		if (!el.hasClass('loading')) {
			el.addClass('loading');
			colspan = (el.attr('title') == 'Application Detail') ? 7 : 6;
			$.get(el.attr('href') + '&ts=' + new Date().getTime(), function(data) {
				row.after('<tr class="data"><td class="cellRightAndBottomBlueSide" colspan="' + colspan +  '"><div class="slider">' + data + '</div></td></tr>');
				$('.slider', row.next()).hide().animate({
					height: 'show',
					opacity: 'show'
				}, function() {
					el.removeClass('loading');
				});
			});
		}
	}
};

var RowRemover = function(e) {
	e.preventDefault();
	$(this).parent().animate({
		height: 'hide',
		opacity: 'hide'
	}, function() {
		$(this).remove()
	});
};

$(function() {
	$('.button[title]').each(function() {
		$(this).button({
			icons: {primary: 'ui-icon-' + this.title}
		}).attr('title', '');
	});
	$('.removeRow').button({
		icons: {primary: 'ui-icon-close'},
		text: false
	}).click(RowRemover);
	$('#addRow').click(function(e) {
		e.preventDefault();
		var filters = $('#filterRows');
		var rows = filters.children();
		var row = parseInt(rows.last().attr('id').split('_')[1]) + 1;
		filters.append('<div id="row_' + row + '"><label for="key_' + row + '">Key: <input type="text" name="key_' + row + '" id="key_' + row + '" /></label> <label for="val_' + row + '">Value: <input type="text" name="val_' + row + '" id="val_' + row + '" /></label> <button class="removeRow">Remove row</button></div>');
		var newRow = $('#row_' + row).hide().animate({
			height: 'show',
			opacity: 'show'
		});
		$('.removeRow', newRow).button({
			icons: {
				primary: 'ui-icon-close'
			},
			text: false
		}).click(RowRemover);
	});
	$('.detail').click(detailLinks);
});
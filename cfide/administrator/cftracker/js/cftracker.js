var detailLinks = function(e) {
	el = $(this);
	e.preventDefault();
	var row = $($(this).parents('tr').get(0));
	if (row.next().hasClass('data')) {
		if (!row.hasClass('loading') && !row.hasClass('unloading')) {
			row.addClass('unloading');
			row.next().children('td').each(function() {
				$(this).children('.slider').animate({
					height: 'hide',
					opacity: 'hide'
				}, function() {
					var newRow = row.next();
					var displayNew = (newRow.data('source') != el.attr('href'));
					newRow.remove();
					row.removeClass('unloading');
					if (displayNew) el.click();
				});
			});
		}
	} else {
		if (!row.hasClass('loading')) {
			row.addClass('loading');
			colspan = (el.attr('title') == 'Session Detail') ? 8 : 7;
			$.get(el.attr('href') + '&ts=' + new Date().getTime(), function(data) {
				row.after('<tr class="data"><td class="cellRightAndBottomBlueSide" colspan="' + colspan +  '"><div class="slider">' + data + '</div></td></tr>');
				newRow = row.next();
				newRow.data('source', el.attr('href'));
				$('.slider', newRow).hide().animate({
					height: 'show',
					opacity: 'show'
				}, function() {
					row.removeClass('loading');
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
			icons: {primary: 'ui-icon-' + this.title},
			text: !(this.innerHTML.length == 0 || this.innerHTML == '&nbsp;')
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
	$('form .action button').click(function(e) {
		el = $(this);
		el.parents('form').children('input[name=action]').val(el.val());
	});
});
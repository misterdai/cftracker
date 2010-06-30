$(function() {
	oTable = $('.dataTable').dataTable({
		bJQueryUI: true,
		sPaginationType: 'full_numbers',
		bAutoWidth: true,
		aoColumns: table.cols,
		aaSorting: table.sorting
	});

	function fnShowHide(iCol) {
		var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
		oTable.fnSetColumnVis( iCol, bVis ? false : true );
	}

	var filter = function() {
		oTable.fnFilter(this.value, $("tfoot th").index(this.parentNode));
	};
	$('#displayCols input').each(function(num, el) {
		this.checked = (oTable.fnSettings().aoColumns[parseInt(this.value, 10)].bVisible);
	}).change(function() {

		oTable.fnSetColumnVis(parseInt(this.value, 10), this.checked);
	});
	
	$('.dataTable tfoot input').keyup(filter);
	$('.dataTable tfoot select').change(filter);
	
	$('#displayCols').dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			Ok: function() {
				$(this).dialog('close');
			}
		}
	});

	$('#selectCols').button({
		icons: {
			primary: 'ui-icon-wrench'
		}
	}).click(function() {
		$('#displayCols').dialog('open');
	});
	
	$('.button[alt]').each(function() {
		$(this).button({
			icons: {primary: 'ui-icon-' + $(this).attr('alt')},
			text: !(this.innerHTML.length == 0 || this.innerHTML == '&nbsp;'),
			disabled: (this.innerHTML.match(/^0$/))
		}).attr('alt', '').click(function(e) {
			if ($(this).button('option', 'disabled')) {
				e.preventDefault();
			}
		});
	});

	var detailLinks = function(e) {
		el = $(this);
		e.preventDefault();
		var row = $($(this).parents('tr').get(0));
		if (row.next().hasClass('data')) {
			if (!row.hasClass('loading') && !row.hasClass('unloading')) {
				$('.detail', row).button({disabled: true});
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
						$('.detail', row).button({disabled: false});
						if (displayNew) el.click();
					});
				});
			}
		} else {
			if (!row.hasClass('loading')) {
				$('.detail', row).button({disabled: true});
				row.addClass('loading');
				colspan = row.get(0).cells.length;
				$.get(el.attr('href') + '&ts=' + new Date().getTime(), function(data) {
					row.after('<tr class="data"><td colspan="' + colspan +  '"><div class="slider">' + data + '</div></td></tr>');
					newRow = row.next();
					newRow.data('source', el.attr('href'));
					$('.slider', newRow).hide().animate({
						height: 'show',
						opacity: 'show'
					}, function() {
						row.removeClass('loading');
						$('.detail', row).button({disabled: false});
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
	
	$('.detail').click(detailLinks);
	
	$('.actions button').each(function(num, el) {
		$(el).button({
			icons: {
				primary: el.className
			}
		}).click(function(e) {
			var form = $(this).parents('form');
/*			if ($('input[type=checkbox][checked]', form).length == 0) {
				e.preventDefault();
				$('<div title="Warning">Please select an item.</div>').dialog({
					modal: true,
					buttons: {
						Ok: function() {
							$(this).dialog('close');
						}
					}
				});
			} else {*/
				$('input[name=action]', form).val(this.value);
			/*}*/
		});
	});

});

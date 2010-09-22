(function($) {
	/*
	 * Function: fnGetColumnData
	 * Purpose:  Return an array of table values from a particular column.
	 * Returns:  array string: 1d data array 
	 * Inputs:   object:oSettings - dataTable settings object. This is always the last argument past to the function
	 *           int:iColumn - the id of the column to extract the data from
	 *           bool:bUnique - optional - if set to false duplicated values are not filtered out
	 *           bool:bFiltered - optional - if set to false all the table data is used (not only the filtered)
	 *           bool:bIgnoreEmpty - optional - if set to false empty values are not filtered from the result array
	 * Author:   Benedikt Forchhammer <b.forchhammer /AT\ mind2.de>
	 */
	$.fn.dataTableExt.oApi.fnGetColumnData = function ( oSettings, iColumn, bUnique, bFiltered, bIgnoreEmpty ) {
		// check that we have a column id
		if ( typeof iColumn == "undefined" ) return new Array();
		
		// by default we only wany unique data
		if ( typeof bUnique == "undefined" ) bUnique = true;
		
		// by default we do want to only look at filtered data
		if ( typeof bFiltered == "undefined" ) bFiltered = true;
		
		// by default we do not wany to include empty values
		if ( typeof bIgnoreEmpty == "undefined" ) bIgnoreEmpty = true;
		
		// list of rows which we're going to loop through
		var aiRows;
		
		// use only filtered rows
		if (bFiltered == true) aiRows = oSettings.aiDisplay; 
		// use all rows
		else aiRows = oSettings.aiDisplayMaster; // all row numbers
	
		// set up data array	
		var asResultData = new Array();
		
		for (var i=0,c=aiRows.length; i<c; i++) {
			iRow = aiRows[i];
			var aData = this.fnGetData(iRow);
			var sValue = aData[iColumn];
			
			// ignore empty values?
			if (bIgnoreEmpty == true && sValue.length == 0) continue;
	
			// ignore unique values?
			else if (bUnique == true && jQuery.inArray(sValue, asResultData) > -1) continue;
			
			// else push the value onto the result data array
			else asResultData.push(sValue);
		}
		
		return asResultData;
	}
}(jQuery));

$(function() {
	var detailLinks = function(e) {
		e.preventDefault();
		var el = $(this);
		var win = $(window);
		var winPos = {
			height: win.height(),
			width: win.width()
		};
		$('<div title="Details - Click to expand when loaded" class="detailDialog"><img src="assets/images/ajax.gif" width="220" height="19" alt="Loading..." /></div>').dialog({
			buttons: {
				Ok: function() {
					$(this).dialog('close');
				}
			},
			close: function(event, ui) {
				$(this).remove();
			},
			height: winPos.height - 100,
			width: winPos.width - 100,
			maxHeight: winPos.height - 50,
			maxWidth: winPos.width - 50,
			modal: true
		})
		.load(el.attr('href') + '&ts=' + new Date().getTime());
	};

	var detailNext = function(e) {
		e.preventDefault();
		var el = $(this);
		var win = $(window);
		var winPos = {
			height: win.height(),
			width: win.width()
		};
		el.next().dialog({
			buttons: {
				Ok: function() {
					$(this).dialog('close');
				}
			},
			close: function(event, ui) {
				$(this).remove();
			},
			height: winPos.height - 100,
			width: winPos.width - 100,
			maxHeight: winPos.height - 50,
			maxWidth: winPos.width - 50,
			modal: true
		});
	};

	oTable = $('.dataTable').dataTable({
		bJQueryUI: true,
		sPaginationType: 'full_numbers',
		bAutoWidth: true,
		aoColumns: table.cols,
		aaSorting: table.sorting,
		fnDrawCallback: function() {
			$('.button[alt]:not(.ui-button)').each(function() {
				$(this).button({
					icons: {primary: 'ui-icon-' + $(this).attr('alt')},
					text: !(this.innerHTML.length == 0 || this.innerHTML == '&nbsp;'),
					disabled: (this.innerHTML.match(/^0$/))
				}).attr('alt', '');
			});
			$('.detail').click(detailLinks);
			$('.nextDetail').click(detailNext);
		}
	});

	function fnShowHide(iCol) {
		var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
		oTable.fnSetColumnVis( iCol, bVis ? false : true );
	}

	var filter = function() {
		var settings = oTable.fnSettings();
		var visCol = $("tfoot th").index(this.parentNode) + 1;
		var cols = settings.aoColumns.length;
		var countVis = 0;
		var col = 0;
		for (var c = 0; c < cols; c++) {
			if (settings.aoColumns[c].bVisible) {
				countVis++;
			}
			if (countVis == visCol) {
				col = c;
				break;
			}
		}
		oTable.fnFilter(this.value, col);
	};
	
	var dc = $('#displayCols');
	if (dc.children().length == 0) {
		var num = parseInt(dc.html(), 10);
		var settings = oTable.fnSettings();
		dc.empty().append('<p>Please select the table columns you would like displayed.</p><ul></ul>');
		var ul = $('ul', dc);
		var checked = '';
		for (var i = num; i < settings.aoColumns.length; i++) {
			checked = (settings.aoColumns[i].bVisible) ? 'checked="checked"' : '';
			ul.append('<li><label for="col' + i + '"><input type="checkbox" name="display" value="' + i + '" id="col' + i + '" ' + checked + ' /> ' + $(settings.aoColumns[i].nTh).text() + '</label></li>');
		}
	}
	
	$('#displayCols input').each(function(num, el) {
		$(el).attr('checked', (oTable.fnSettings().aoColumns[parseInt(this.value, 10)].bVisible) ? 'checked' : null);
	}).click(function() {
		var col = parseInt(this.value, 10);
		if (this.checked) {
			oTable.fnSetColumnVis(col, this.checked);
			var settings = oTable.fnSettings();
			var colElNum = 0;
			for (var c = 0; c < col; c++) {
				if (settings.aoColumns[c].bVisible) {
					colElNum++;
				}
			}
			var sel = $('select', $('.dataTable tfoot th').get(colElNum));
			sel.html(fnCreateOptions(oTable.fnGetColumnData(col)));
			sel.change(filter);
		} else {
			oTable.fnFilter('', col);			
			oTable.fnSetColumnVis(col, this.checked);
		}
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
	
	var RowRemover = function(e) {
		e.preventDefault();
		$(this).parent().animate({
			height: 'hide',
			opacity: 'hide'
		}, function() {
			$(this).remove()
		});
	};
	
	$('.actions button').each(function(num, el) {
		$(el).button({
			icons: {
				primary: el.className
			}
		}).click(function(e) {
			var form = $(this).parents('form');
			$('input[name=action]', form).val(this.value);
		});
	});

	function fnCreateOptions( aData )
	{
		var r='<option value=""></option>', i, iLen=aData.length;
		for ( i=0 ; i<iLen ; i++ )
		{
			r += '<option value="'+aData[i]+'">'+aData[i]+'</option>';
		}
		return r;
	}

	$('.dataTable tfoot select.build').each(function () {
		var col = $(this).parent().get(0).cellIndex;
		$(this).html(fnCreateOptions(oTable.fnGetColumnData(col)));
	});
});

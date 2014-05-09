{ft_include file='header.tpl'}

  <table cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td width="45"><a href="../"><img src="{$images_url}/icon_forms.gif" border="0" width="34" height="34" /></a></td>
    <td class="title">{$form_info.form_name}</td>
    <td align="right" valign="top">

      {if $form_views|@count > 1}
        <select onchange="window.location='{$same_page}?page=1&view=' + this.value">
          <optgroup label="{$LANG.word_views}">
	          {foreach from=$form_views key=k item=i}
	            <option value="{$i.view_id}" {if $view_id == $i.view_id}selected{/if}>{$i.view_name}</option>
	          {/foreach}
          </optgroup>
        </select>
      {/if}

    </td>
  </tr>
  </table>

  {* if there is at least one submission in this form (and not necessary in this current search or View),
     always display the search form *}
  {if $total_form_submissions == 0}
    <p>
      {$LANG.text_no_submissions_found}
    </p>

    {if $view_info.may_add_submissions == "yes"}
      <input type="button" id="add_submission" value="{$LANG.word_add}" onclick="window.location='{$same_page}?add_submission'" />
    {/if}
  {else}

  {ft_include file="messages.tpl"}

  <div id="search_form">

    <form action="{$same_page}" method="post" name="search_form" onsubmit="return rsv.validate(this, rules)">
      <input type="hidden" name="search" value="1" />
      <input type="hidden" name="select_all" value="{if $curr_view_select_all == "yes"}1{/if}"  />

      <table cellspacing="0" cellpadding="0" id="search_form_table">
      <tr>
        <td class="blue" width="70">{$LANG.word_search}</td>
        <td>
          <table cellspacing="2" cellpadding="0">
          <tr>
            <td>
              {form_view_fields_dropdown name_id="search_field" form_id=$form_id view_id=$view_id
                  blank_option_value="all" blank_option_text=$LANG.phrase_all_fields
                  onchange="ms.change_search_field(this.value)" onkeyup="ms.change_search_field(this.value)"
                  default=$curr_search_fields.search_field}
            </td>
            <td>
              <div id="search_dropdown_section"
                {if $curr_search_fields.search_field != "submission_date" &&
                    $curr_search_fields.search_field != "last_modified_date"}style="display: none"{/if}>
                {date_range_search_dropdown name_id="search_date" form_id=$form_id view_id=$view_id
                  default=$curr_search_fields.search_date}
              </div>
            </td>
          </tr>
          </table>
        </td>
        <td width="20" align="center">{$LANG.word_for}</td>
        <td>
          <input type="text" style="width: 120px;" name="search_keyword" value="{$curr_search_fields.search_keyword|escape}" />
        </td>
        <td>
          <input type="submit" name="search" value="{$LANG.word_search}" />
          <input type="button" name="" value="{$LANG.phrase_show_all}" onclick="window.location='index.php?page=1&reset=1'"
            {if $search_num_results < $view_num_results}class="bold"{/if} />
        </td>
      </tr>
      </table>

    </form>

  </div>

  <br />

  {$pagination}

  {if $search_num_results == 0}
    <div class="notify yellow_bg">
      <div style="padding:8px">
        There are no results with this search criteria / View.
      </div>
    </div>
  {else}

    <form name="current_form" action="{$same_page}" method="post">

    {template_hook location="client_submission_listings_top"}

    <table class="list_table submissions_table" id="submissions_table" cellpadding="1" cellspacing="1" border="0" width="650">
    <tr>
      <th align="center" width="25"> </th>
      {foreach from=$display_fields key=k item=i}
        {if $i.is_sortable == "yes"}
          {assign var="up_down" value=""}
          {* determine the column sorting (if included in query string, reverse) *}
          {if     $order == $i.col_name|cat:'-DESC'}
            {assign var=order_col value="&order=`$i.col_name`-ASC"}
            {assign var=up_down value="<img src=\"`$theme_url`/images/sort_down.gif\" />"}
          {elseif $order == $i.col_name|cat:'-ASC'}
            {assign var=order_col value="&order=`$i.col_name`-DESC"}
            {assign var=up_down value="<img src=\"`$theme_url`/images/sort_up.gif\" />"}
          {else}
            {assign var=order_col value="&order=`$i.col_name`-ASC"}
          {/if}
          <th{if $i.custom_width} width="{$i.custom_width}"{/if} class="sortable_col {if $up_down}over{/if}">
            <a href="{$same_page}?{$pass_along_str}{$order_col}">{$i.field_title} {$up_down}</a>
          </th>
        {else}
          <th{if $i.custom_width} width="{$i.custom_width}"{/if}>{$i.field_title}</th>
        {/if}

      {/foreach}
      <th class="edit"> </th>
    </tr>

    {foreach from=$search_rows key=k item=search_row}
      {assign var=submission_id value=$search_row.submission_id}
      {assign var=precheck value=""}
      {if $submission_id|in_array:$preselected_subids}
        {assign var=precheck value="checked"}
      {/if}
      <tr class="unselected_row_color">
        <td align="center"><input type="checkbox" class="select_row_cb" name="submissions[]" value="{$submission_id}" {$precheck} /></td>
	      {foreach from=$display_fields key=k2 item=curr_field}
	        {assign var=col_name value=$curr_field.col_name}
	        <td>
	          {if $curr_field.truncate == "truncate" && $curr_field.custom_width}
	            <div class="truncate" style="width:{$curr_field.custom_width}px">
	          {elseif $curr_field.truncate == "truncate"}
	            <div class="truncate_no_fixed_width">
	          {/if}
	            {display_custom_field form_id=$form_id view_id=$view_id submission_id=$submission_id
	              value=$search_row.$col_name field_info=$curr_field field_types=$field_types}
	          {if $curr_field.truncate == "truncate"}
	            </div>
	          {/if}
	        </td>
        {/foreach}
        <td class="edit"><a href="edit_submission.php?form_id={$form_id}&view_id={$view_id}&submission_id={$submission_id}" title="{$LANG.word_edit}"></a></td>
      </tr>
    {/foreach}
    </table>

    <div style="padding-top: 5px; padding-bottom: 5px;">
      <div style="float:right; padding:1px" id="display_num_selected_rows"
        {if $preselected_subids|@count == 0}
          class="light_grey"
        {else}
          class="green"
        {/if}>
        {$preselected_subids|@count}
      </div>

      {template_hook location="client_submission_listings_buttons1"}

      {if $view_info.may_add_submissions == "yes"}
        <input type="button" id="add_submission" value="{$LANG.word_add}" onclick="window.location='{$same_page}?add_submission'" />
      {/if}

      {template_hook location="client_submission_listings_buttons2"}

      <input type="button" id="select_button" value="{$LANG.phrase_select_all_on_page}" onclick="ms.select_all_on_page();" />
      <input type="button" id="unselect_button" value="{$LANG.phrase_unselect_all}" onclick="ms.unselect_all()" />

      {template_hook location="client_submission_listings_buttons3"}

      {if $view_info.may_delete_submissions == "yes"}
        <input type="button" value="{$LANG.word_delete}" class="red" onclick="ms.delete_submissions()" />
      {/if}

      {template_hook location="client_submission_listings_buttons4"}
    </div>

    {template_hook location="client_submission_listings_bottom"}

    </form>

    {* display the export options - TODO
    {module_function name=export_manager_export_options account_type="client" account_id=$SESSION.account.account_id}
*}

    {/if}

  {/if}

{ft_include file='footer.tpl'}
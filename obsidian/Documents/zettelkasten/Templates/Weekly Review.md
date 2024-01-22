<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const dayFormat = 'YYYY-MM-DD'
const weekFormat = 'gggg-[W]ww'
const monday = moment(tp.file.title, weekFormat).format('YYYY-MM-DD');
const tuesday = moment(monday,dayFormat).add(1, 'days').format('YYYY-MM-DD');
const wednesday = moment(tuesday,'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');
const thursday = moment(wednesday,'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');
const friday = moment(thursday,'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');
const saturday = moment(friday,'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');
const sunday = moment(saturday,'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');

if (tp.file.title === 'Untitled') {
	tp.file.title = tp.date.now(weekFormat);
	await tp.file.move(`/01-Calendar/02-Weekly/${tp.file.title}`);
}
%>
# <% tp.file.title %>

**[[<%moment(tp.file.title, 'gggg-[W]ww').subtract(1, 'weeks').format('gggg-[W]ww')%>|<< Previous Week]] | [[<%moment(tp.file.title, 'gggg-[W]ww').add(1, 'weeks').format('gggg-[W]ww')%>|Next Week >>]]**
> [!summary]+ Days of the Week
> **[[01-Calendar/01-Daily/<%monday%>|Monday]]**
> **[[01-Calendar/01-Daily/<%tuesday%>|Tuesday]]**
> **[[01-Calendar/01-Daily/<%wednesday%>|Wedneday]]**
> **[[01-Calendar/01-Daily/<%thursday%>|Thursday]]**
> **[[01-Calendar/01-Daily/<%friday%>|Friday]]**
> **[[01-Calendar/01-Daily/<%saturday%>|Saturday]]**
> **[[01-Calendar/01-Daily/<%sunday%>|Sunday]]**
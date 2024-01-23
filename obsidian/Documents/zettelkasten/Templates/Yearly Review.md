<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const quarterFormat = 'YYYY-[Q]Q';
const quarterlyPath = '/01-Calendar/04-Quarterly/';
const yearFormat = 'YYYY';
const yearlyPath = '/01-Calendar/05-Yearly/';

console.log(tp.file.title)
if (tp.file.title === 'Untitled') {

	tp.file.title = tp.date.now(yearFormat);
	await tp.file.move(`${yearlyPath}${tp.file.title}`);
}

const nextYear = moment(tp.file.title, yearFormat).add(1, 'Y').format(yearFormat);
const previousYear = moment(tp.file.title, yearFormat).subtract(1, 'Y').format(yearFormat);

const quarter1 = moment(tp.file.title, yearFormat).format(quarterFormat);
const quarter2 = moment(quarter1, quarterFormat).add(1, 'Q').format(quarterFormat);
const quarter3 = moment(quarter2, quarterFormat).add(1, 'Q').format(quarterFormat);
const quarter4 = moment(quarter3, quarterFormat).add(1, 'Q').format(quarterFormat);
%>
# <%tp.file.title%>

**[[<%yearlyPath%><%previousYear%>|<< Previous Year]]** | **[[<%yearlyPath%><%nextYear%>|Next Year >>]]**

> [!summary]+ Quarters of the Year
> **[[<%quarterlyPath%><%quarter1%>|1st Quarter]]**
> **[[<%quarterlyPath%><%quarter2%>|2nd Quarter]]**
> **[[<%quarterlyPath%><%quarter3%>|3rt Quarter]]**
> **[[<%quarterlyPath%><%quarter4%>|4th Quarter]]**
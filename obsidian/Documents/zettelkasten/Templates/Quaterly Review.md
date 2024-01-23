<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const monthFormat = 'YYYY-MM';
const monthlyPath = '/01-Calendar/03-Monthly/';
const quarterlyFormat = 'YYYY-[Q]Q';
const quarterlyPath = '/01-Calendar/04-Quarterly/';
const yearlyFormat = 'YYYY';
const yearlyPath = '/01-Calendar/05-Yearly/';

if (tp.file.title === 'Untitled') {
	tp.file.title = tp.date.now(quarterlyFormat);
	await tp.file.move(`${quarterlyPath}${tp.file.title}`);
}

const currentYear = moment(tp.file.title, quarterlyFormat).format(yearlyFormat);
const nextQuarter = moment(tp.file.title, quarterlyFormat).add(1, 'Q').format(quarterlyFormat);
const previousQuarter = moment(tp.file.title, quarterlyFormat).subtract(1, 'Q').format(quarterlyFormat);

const month1 = moment(tp.file.title, quarterlyFormat).format(monthFormat);
const month2 = moment(month1, monthFormat).add(1, 'M').format(monthFormat);
const month3 = moment(month2, monthFormat).add(1, 'M').format(monthFormat);
%>
# <%tp.file.title%>

**[[<%quarterlyPath%><%previousQuarter%>|<< Previous Quarter]]** | **[[<%yearlyPath%><%currentYear%>|Current Year]]** | **[[<%quarterlyPath%><%nextQuarter%>|Next Quarter >>]]**

> [!summary]+ Months of the Quarter
> **[[<%monthlyPath%><%month1%>|1st Month]]**
> **[[<%monthlyPath%><%month2%>|2nd Month]]**
> **[[<%monthlyPath%><%month3%>|3rt Month]]**
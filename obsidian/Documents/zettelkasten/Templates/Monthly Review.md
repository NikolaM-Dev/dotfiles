<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const extendMonthFormat = 'MMMM YYYY';
const monthFormat = 'YYYY-MM';
const monthlyPath = '/01-Calendar/03-Monthly/';
const quarterlyPath = '/01-Calendar/04-Quarterly/';
const weekFormat = 'gggg-[W]ww';
const weeklyPath = '/01-Calendar/02-Weekly/';
const quarterlyFormat = 'YYYY-[Q]Q';

if (tp.file.title === 'Untitled') {
	tp.file.title = tp.date.now(monthFormat);
	await tp.file.move(`%{monthlyPath}${tp.file.title}`);
}

const h1 = moment(tp.file.title, monthFormat).format(extendMonthFormat)

const currentQuarter = moment(tp.file.title, monthFormat).format(quarterlyFormat);
const nextMonth = moment(tp.file.title, monthFormat).add(1, 'M').format(monthFormat);
const previousMonth = moment(tp.file.title, monthFormat).subtract(1, 'M').format(monthFormat);

const week1 = moment(tp.file.title, monthFormat).format(weekFormat);
const week2 = moment(week1, weekFormat).add(1, 'w').format(weekFormat);
const week3 = moment(week2, weekFormat).add(1, 'w').format(weekFormat);
const week4 = moment(week3, weekFormat).add(1, 'w').format(weekFormat);
%>
# <%h1%>

**[[<%monthlyPath%><%previousMonth%>|<< Previous Month]]** | **[[<%quarterlyPath%><%currentQuarter%>|Current Quarter]]** | **[[<%monthlyPath%><%nextMonth%>|Next Month >>]]**

> [!summary]+ Weeks of the Month
> **[[<%weeklyPath%><%week1%>|1st Week]]**
> **[[<%weeklyPath%><%week2%>|2nd Week]]**
> **[[<%weeklyPath%><%week3%>|3rt Week]]**
> **[[<%weeklyPath%><%week4%>|4th Week]]**
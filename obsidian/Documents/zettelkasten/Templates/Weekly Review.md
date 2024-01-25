<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const dailyPath = '/01-Calendar/01-Daily/';
const dayFormat = 'YYYY-MM-DD';
const monthFormat = 'YYYY-MM';
const monthlyPath = '01-Calendar/03-Monthly/';
const weekFormat = 'gggg-[W]ww';
const weeklyPath = '/01-Calendar/02-Weekly/';

if (tp.file.title === 'Untitled') {
  tp.file.title = tp.date.now(weekFormat);
  await tp.file.move(`${weeklyPath}${tp.file.title}`);
}

const previousWeekSlug = moment(tp.file.title, weekFormat).subtract(1, 'w').format(weekFormat);
const previousWeekSufix = '|<< Previeous Week';
const previousWeek = `${weeklyPath}${previousWeekSlug}${previousWeekSufix}`;

const nextWeekSlug = moment(tp.file.title, weekFormat).add(1, 'w').format(weekFormat);
const nextWeekSufix = '|Next Week >>';
const nextWeek = `${weeklyPath}${nextWeekSlug}${nextWeekSufix}`

const currentMonthSufix = '|Current Month';
const currentMonthSlug = moment(tp.file.title, weekFormat).format(monthFormat);
const currentMonth = `${monthlyPath}${currentMonthSlug}${currentMonthSufix}`

const monday = moment(tp.file.title, weekFormat).format(dayFormat);
const tuesday = moment(monday, dayFormat).add(1, 'd').format(dayFormat);
const wednesday = moment(tuesday, dayFormat).add(1, 'd').format(dayFormat);
const thursday = moment(wednesday, dayFormat).add(1, 'd').format(dayFormat);
const friday = moment(thursday, dayFormat).add(1, 'd').format(dayFormat);
const saturday = moment(friday, dayFormat).add(1, 'd').format(dayFormat);
const sunday = moment(saturday, dayFormat).add(1, 'd').format(dayFormat);
%>

# <%tp.file.title%>

**[[<%previousWeek%>]]** | **[[<%currentMonth%>]]** | **[[<%nextWeek%>]]**

> [!summary]+ Days of the Week
> **[[<%dailyPath%><%monday%>|Monday]]**
> **[[<%dailyPath%><%tuesday%>|Tuesday]]**
> **[[<%dailyPath%><%wednesday%>|Wedneday]]**
> **[[<%dailyPath%><%thursday%>|Thursday]]**
> **[[<%dailyPath%><%friday%>|Friday]]**
> **[[<%dailyPath%><%saturday%>|Saturday]]**
> **[[<%dailyPath%><%sunday%>|Sunday]]**

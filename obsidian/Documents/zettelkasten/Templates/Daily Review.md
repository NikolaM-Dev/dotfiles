<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
const dailyPath = '/01-Calendar/01-Daily/';
const dayFormat = 'YYYY-MM-DD';
const extendDayFormat = 'dddd, DD MMMM YYYY';
const weekFormat = 'gggg-[W]ww';
const weeklyPath = '/01-Calendar/02-Weekly/';

if (tp.file.title === 'Untitled') {
  tp.file.title = tp.date.now(dayFormat);

  await tp.file.move(`${dailyPath}${tp.file.title}`);
}

const h1 = moment(tp.file.title, dayFormat).format(extendDayFormat);

const currentWeek= tp.date.now(weekFormat, 0, tp.file.title, dayFormat);
const tomorrow = tp.date.now(dayFormat, 1, tp.file.title, dayFormat);
const yesterday = tp.date.now(dayFormat, -1, tp.file.title, dayFormat);
%>
# <%h1%>

**[[<%dailyPath%><%yesterday%>|<< Yesterday]]** | **[[<%weeklyPath%><%currentWeek%>|Current Week]]** | **[[<%dailyPath%><%tomorrow%>|Tomorrow >>]]**

# ✅ TODO's

**Personal**
- [ ] 1

**Work**
- [ ] 1
<%"---"%>
<%"is_public: false"%>
<%"---"%>
<%*
if (tp.file.title === 'Untitled') {
	tp.file.title = tp.date.now('YYYY-MM-DD');
	await tp.file.move(`/01-Calendar/01-Daily/${tp.file.title}`);
}
%>
# <% moment(tp.file.title,'YYYY-MM-DD').format('dddd, DD MMMM YYYY')
%>

**[[01-Calendar/01-Daily/<%tp.date.now('YYYY-MM-DD', -1, tp.file.title, 'YYYY-MM-DD')%>|<< Yesterday]] | [[01-Calendar/02-Weekly/<%tp.date.now('gggg-[W]ww', 0, tp.file.title, 'YYYY-MM-DD')%>|Current Week]] |  [[01-Calendar/01-Daily/<%tp.date.now('YYYY-MM-DD', 1, tp.file.title, 'YYYY-MM-DD')%>|Tomorrow >>]]**
# ✅ TODO's
**Personal**
- [ ] 1
**Work**
- [ ] 1

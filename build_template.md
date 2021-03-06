<?xml version="1.0" encoding="UTF-8"?>

<project name="jhopraesentation">

	<target name="prepare">
		<property environment="env" />
		<delete includeemptydirs="true">
			<fileset dir="0_TMP" />
			<fileset dir="0_OUT" />
			<fileset dir="${env.local_www_dir}/${ant.project.name}" />
		</delete>
	</target>

	<target name="reveal" unless="done">
		<exec executable="upp" output="0_TMP/${ant.project.name}.md">
			<arg line="-l html5.lua -l ModeSlides.lua ${ant.project.name}.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="${ant.project.name}.md -t revealjs --slide-level 3 -s -i -V revealjs-url='.' -o ${ant.project.name}.html" />
		</exec>
		<copy todir="${env.local_www_dir}/${ant.project.name}/dist">
			<fileset dir="${env.HOME}/jho-lib/reveal.js/dist" />
		</copy>
		<copy todir="${env.local_www_dir}/${ant.project.name}/plugin">
			<fileset dir="${env.HOME}/jho-lib/reveal.js/plugin" />
		</copy>
	</target>

	<target name="revealSlides" depends="prepare" unless="done">
		<antcall target="reveal" />
		<copy file="0_TMP/${ant.project.name}.html" tofile="${env.local_www_dir}/${ant.project.name}/index.html" />
		<property name="done" value="done" />
	</target>

	<target name="revealHandout" depends="prepare" unless="done">
		<antcall target="reveal" />
		<exec executable="sed" dir="0_TMP/">
			<arg line="-i '/^# /d' ${ant.project.name}.md" />
		</exec>
		<exec executable="sed" dir="0_TMP/">
			<arg line="-i '/^## /d' ${ant.project.name}.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="${ant.project.name}.md -t revealjs --slide-level 3 -s -i -V revealjs-url='.' -o ${ant.project.name}-handout.html" />
		</exec>
		<copy file="0_TMP/${ant.project.name}-handout.html" todir="${env.local_www_dir}/${ant.project.name}" />
		<exec executable="decktape">
			<arg line="reveal -s 1680x1050 --screenshots --screenshots-directory=./ http://${env.local_www_server}/${ant.project.name}/${ant.project.name}-handout.html 0_TMP/${ant.project.name}-handout-slides.pdf" />
		</exec>
		<exec executable="upp" output="0_TMP/${ant.project.name}-handout.md">
			<arg line="-l context.lua -l ModeHandout.lua ${ant.project.name}.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="${ant.project.name}-handout.md -t context -s -o ${ant.project.name}-handout-con.tex" />
		</exec>
		<exec executable="context" dir="0_TMP/" >
			<arg line="${ant.project.name}-handout-con.tex" />
		</exec>
		<move file="0_TMP/${ant.project.name}-handout-con.pdf" tofile="0_OUT/${ant.project.name}-handout.pdf" />
	        <property name="done" value="done" />
	</target>

	<target name="revealNotes" depends="prepare" unless="done">
		<antcall target="reveal" />
		<exec executable="sed" dir="0_TMP/">
			<arg line="-i '/^# /d' ${ant.project.name}.md" />
		</exec>
		<exec executable="pandoc" dir="TMP/">
			<arg line="${quelle}.md -t beamer --slide-level 3 -i -o ${quelle}.tex" />
		</exec>
		<exec executable="lualatex" dir="TMP/">
			<arg line="${quelle}-handout.tex" />
		</exec>
		<exec executable="lualatex" dir="TMP/">
			<arg line="${quelle}-handout.tex" />
		</exec>
		<exec executable="pp" output="TMP/${quelle}.md">
			<arg line="-Dmodus=notes ${quelle}.md" />
		</exec>
		<exec executable="pandoc" dir="TMP/">
			<arg line="${quelle}.md -t context -s -o ${quelle}-con.tex" />
		</exec>
		<exec executable="context" dir="TMP/" >
			<arg line="${quelle}-con.tex" />
		</exec>
		<move file="TMP/${quelle}-con.pdf" tofile="OUT/${quelle}.pdf" />
	        <property name="done" value="done" />
	</target>

	<target name="beamerSlides" depends="prepare"  unless="done">
		<exec executable="upp" output="0_TMP/${ant.project.name}-beamer.md">
			<arg line="-l latex.lua -l ModeSlides.lua ${ant.project.name}.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="${ant.project.name}-beamer.md -t beamer --slide-level 3 -i -s -o ${ant.project.name}-beamer.tex" />
		</exec>
		<exec executable="lualatex" dir="0_TMP/">
			<arg line="${ant.project.name}-beamer.tex" />
		</exec>
		<exec executable="lualatex" dir="0_TMP/">
			<arg line="${ant.project.name}-beamer.tex" />
		</exec>
		<exec executable="lualatex" dir="0_TMP/">
			<arg line="${ant.project.name}-beamer.tex" />
		</exec>
		<move file="0_TMP/${ant.project.name}-beamer.pdf" todir="0_OUT" />
		<property name="done" value="done" />
	</target>

</project>

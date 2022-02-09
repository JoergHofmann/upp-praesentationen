<?xml version="1.0" encoding="UTF-8"?>

<project name="jhopraesentation">

	<target name="prepare">
		<property environment="env" />
		<echo message="JHO_LIB: ${env.HOME}/jho-lib" />
		<delete includeemptydirs="true">
			<fileset dir="0_TMP" />
			<fileset dir="${env.local_www_dir}/${ant.project.name}" />
		</delete>
		<delete>
			<fileset dir="0_OUT" />
		</delete>
	</target>

	<target name="revealSlides" depends="prepare" unless="done">
		<antcall target="reveal" />
		<property name="done" value="done" />
	</target>

	<target name="reveal" unless="done">
		<exec executable="upp" output="0_TMP/${ant.project.name}.md">
			<arg line="-l html5.lua make-slides.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="${ant.project.name}.md -t revealjs --slide-level 3 -s -i -V revealjs-url='.' -o index.html" />
		</exec>
		<copy todir="${env.local_www_dir}/${ant.project.name}/dist">
			<fileset dir="${env.HOME}/jho-lib/reveal.js/dist" />
		</copy>
		<copy todir="${env.local_www_dir}/${ant.project.name}/plugin">
			<fileset dir="${env.HOME}/jho-lib/reveal.js/plugin" />
		</copy>
		<copy file="0_TMP/index.html" todir="${env.local_www_dir}/${ant.project.name}" />
	</target>

	<target name="beamerSlides" depends="prepare"  unless="done">
		<exec executable="upp" output="0_TMP/${quelle}.md">
			<arg line="${quelle}-slides.md" />

		</exec>
		<exec executable="pandoc" dir="TMP/">
			<arg line="${quelle}.md -t beamer --slide-level 3 -i -o ${quelle}.html" />
		</exec>
		<move file="TMP/${quelle}.html" todir="OUT" />
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
			<arg line="${ant.project.name}.md -t revealjs --slide-level 3 -s -i -V revealjs-url='.' -o handout.html" />
		</exec>
		<copy file="0_TMP/handout.html" todir="${env.local_www_dir}/${ant.project.name}" />
		<exec executable="decktape">
			<arg line="reveal -s 1680x1050 --screenshots --screenshots-directory=./ http://${env.local_www_server}/${ant.project.name}/handout.html 0_TMP/handout.pdf" />
		</exec>
		<exec executable="upp" output="0_TMP/handout.md">
			<arg line="-l context.lua make-handout.md" />
		</exec>
		<exec executable="pandoc" dir="0_TMP/">
			<arg line="handout.md -t context -s -o handout-con.tex" />
		</exec>
		<exec executable="context" dir="0_TMP/" >
			<arg line="handout-con.tex" />
		</exec>
		<move file="0_TMP/handout-con.pdf" tofile="0_OUT/${ant.project.name}-handout.pdf" />
	        <property name="done" value="done" />
	</target>

	<target name="notes" depends="prepare" unless="done">
		<copy file="MakeNotes.tex" tofile="TMP/${quelle}-notes.tex" />
		<copy file="MakeHandout.tex" tofile="TMP/${quelle}-handout.tex" />
		<exec executable="pp" output="TMP/${quelle}.md">
			<arg line="-Dmodus=slides ${quelle}.md" />
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
	<target name="LuaLib">
		<echo message="Jetzt geht's los." />
		<copy file="${ant.project.name}.lua" todir="../../../.local/lib/upp" />
	</target>
</project>
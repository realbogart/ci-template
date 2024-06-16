cmake_minimum_required (VERSION 3.26)

set(project_name template)

project(${project_name})

add_executable(${project_name})

target_sources(${project_name} PRIVATE main.cpp)

install(TARGETS ${project_name} DESTINATION bin)

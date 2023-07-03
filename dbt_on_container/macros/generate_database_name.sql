{# Default Behaviour #}
{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- if custom_database_name is none -%}

        {{ default_database }}

    {%- else -%}

        {{ custom_database_name | trim }}

    {%- endif -%}

{%- endmacro %}


{#---------------------------------------------------------#}

{# Custom Behaviour 

{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- set env = ['UAT', 'PRD'] -%}

    {%- if target.name  in env  -%}
        {%- if custom_database_name is none -%}

            {{ default_database }}_{{ target.name | trim }}

        {%- else -%}

            {{ custom_database_name | trim }}_{{ target.name | trim }}

        {%- endif -%}
    
    {%- else -%}
        {%- if custom_database_name is none -%}

            {{ default_database }}_DEV

        {%- else -%}

            {{ custom_database_name | trim }}_DEV
        {%- endif -%}
    {%- endif -%}

{%- endmacro %}

#}

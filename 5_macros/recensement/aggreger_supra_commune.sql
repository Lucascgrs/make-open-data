{% macro aggreger_supra_commune(theme, nouveau_niveau_geo) %}

{% set libelle_logement_query %}

  SELECT DISTINCT 
  libelle_a_afficher_apres_aggregation
  FROM {{ ref('logement_2020_valeurs') }}
  WHERE theme = '{{ theme }}'
{% endset %}

{% set libelle_logement_resultats = run_query(libelle_logement_query) %}


{% set libelle_logement_liste = ['nombre_de_menage_base_ou_logements_occupee', 'nombre_de_logements_occasionnels',
                                 'nombre_de_logements_residences_secondaires', 'nombre_de_logements_vacants',
                                 'nombre_de_logements_total_tous_status_occupation'] %}
{% for row in libelle_logement_resultats %}
    {% do libelle_logement_liste.append(row[0]) %}
{% endfor %}


select {{ nouveau_niveau_geo }},
{% for libelle in  libelle_logement_liste%}
    SUM("{{ libelle }}") as "{{ libelle }}"
    {% if not loop.last %} , {% endif %}
{% endfor %}
from {{ ref(theme+'_communes')}}
where {{ nouveau_niveau_geo }} is not null --- A enlever après avoir bien milesimé les données recensement (i.e. pas de commune manquante)
group by {{ nouveau_niveau_geo }}

{% endmacro %}
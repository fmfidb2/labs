# Session 9 - Elasticsearch

## Setup

```
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.9
```

## Labs

The assignment is to find a publicly available dataset, import it into Elasticsearch and write down at least two queries:

1. a query which would allow to search for records using a textual input. Depending on your dataset this might be a name of the city or of a person etc.
2. a query which would give you some interesting (meaningful) aggregation from the given data.

Don't write any front-end code or UI, just the import code and the Elasticsearch queries. The data import script/program can be written in any language of your choice. The queries are simple JSON strings and you can use Postman, curl or any other HTTP client library to test/debug them.

If you do not know where to search for datasets, you can try https://data.gov.sk or https://data.gov.uk. Many interesting datasets can be found on websites of various institutions. For instance, here you have datasets of consumption of medicinal products for human use in the Slovak Republic - https://nczisk.sk/Statisticke_vystupy/Tematicke_statisticke_vystupy/TOP-50-liekov/Spotreba_humannych_liekov_zdravotnickych_pomocok_dietetickych_potravin_SR/Pages/Datasety-spotreby-humannych-liekov-v-Slovenskej-republike.aspx


As a rough guideline:

1. Find a dataset which is in a CSV/JSON file or spreadsheet which can be easily turned into CSV.
2. Once you have the data, design the document, e.g., for my example with medicinal products above:

```
{
  "drug_name": "Dolgina 37,5 mg/325 mg tbl 30x37,5 mg/325 mg (blis.priehľ.PVC/PVDC/Al)",
  "area": "Nervový systém",
  "type": "Analgetiká",
  "producer": "G.L.Pharma GmbH",
  "producer_country": Rakúsko,
  "delivery_type": "výdaj z nemocničnej lekárne pre vlastnú nemocnicu",
  "number_of_packages": 9
}
```

3. Prepare a mapping, feel free to do it "by hand", e.g. via Postman/curl, you don't need to write code for this.
4. Write a code in a language of your choice which will scroll through the dataset, build JSON documents and index them in Elasticsearch. You don't need a library specifically for "Elasticsearch", just use an HTTP client library. Most of the "elasticsearch" libraries that you can find are probably overkill for this lab, as they try to provide ORM functionalities. You do not need to ingest the whole dataset of your choice, few hundreds of documents will be enough.
5. You can always check the data in elasticsearch by running a simple `GET` request at the `_search` endpoint.
6. Once you have the data, write the Elasticsearch query. It should be really simple, a match query with an aggregation.

# Precision-100-Migration-Templates

This is a repository of commonly used Migration templates. A migration template is defined by a `Migration Designer`. Templates can be functionality driven, where each functional module is migrated independently or it can be activity driven where all activities such as `extraction` etc is performed for all functional modules at or they can be a mix of both.

The convention followed for naming the templates is `source_destination_type` - e.g. eq3_finacle_functional` for an equation to finacle migration being done using a functionality based strategy. However it is not uncommon to see customer names prefixed or suffixed or used as is for the name.

In many places migrations are done per country - in which case the same template is used to create multiple `migrations`.


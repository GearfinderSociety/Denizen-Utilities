utility_blockcheck_command:
    debug: false
    type: command
    name: block-check
    description: Displays info about the target block.
    usage: /block-check
    aliases:
    - rumi-check
    permission: gear.utilities.rumi
    script:
    - define block_location <player.cursor_on[10].if_null[none]>
    - if <[block_location]> != none:
        - define null_sides "Not a custom sided block."
        - define null_music "Not a custom noteblock."
        - define null_power "Not switched."
        - define block_material <[block_location].material>
        - define block_material_basic <[block_location].material.name>
        - define block_material_sides <[block_location].material.faces.if_null[<[null_sides]>]>
        - define block_instrument <[block_location].material.instrument.if_null[<[null_music]>]>
        - define block_note <[block_location].material.note.if_null[<[null_music]>]>
        - define block_switched <[block_location].material.switched.if_null[<[null_power]>]>

        - narrate <&color[#D9C69C]><&m>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯<reset><white>
        - narrate "<&color[#D9C69C]>Block Location: <&7><[block_location]>"
        - narrate "<&color[#D9C69C]>Block Power: <&7><[block_switched]>"
        - narrate "<&color[#D9C69C]>Block Info: <&7><[block_material]>"
        - narrate <&color[#D9C69C]><&m>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯<reset><white>
        - narrate "<&color[#D9C69C]>Block Name: <&7><[block_material_basic]>"
        - narrate "<&color[#D9C69C]>Block Sides: <&7><[block_material_sides]>"
        - narrate <&color[#D9C69C]><&m>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯<reset><white>
        - narrate "<&color[#D9C69C]>Instrument: <&7><[block_instrument]>"
        - narrate "<&color[#D9C69C]>Note: <&7><[block_note]>"
        - narrate <&color[#D9C69C]><&m>⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯<reset><white>

roseate_voucher_event_handler:
    debug: false
    type: world
    events:
        on server start:
        - run roseate_vouchers_yaml_handler
        on player right clicks block:
        - if <context.item.has_flag[voucher]>:
            - define voucher_type <context.item.flag[voucher].if_null[invalid]>
            - if <[voucher_type]> != invalid:
                - ratelimit <player> 3s
                - foreach <yaml[rv_voucher_<[voucher_type]>].parsed_key[<[voucher_type]>.Effects.Commands]> as:commands:
                    - execute as_server <[commands]>
                - take iteminhand

roseate_vouchers_yaml_handler:
    debug: false
    type: task
    script:
    - if <server.has_file[../RoseateVouchers/config.yml]>:
        - ~yaml load:../RoseateVouchers/config.yml id:rv_yaml_vouchers
        - run roseate_vouchers_yaml_loader

    - else:
        - yaml create id:rv_yaml_vouchers

        - yaml id:rv_yaml_vouchers set RoseateVouchers.Vouchers.diamond_claim.Enabled:true
        - yaml id:rv_yaml_vouchers set RoseateVouchers.Vouchers.emerald_claim.Enabled:false
        - yaml id:rv_yaml_vouchers set RoseateVouchers.Vouchers.execute_tasks.Enabled:true
        - yaml id:rv_yaml_vouchers set RoseateVouchers.Vouchers.set_permgroup.Enabled:true

        - ~yaml savefile:../RoseateVouchers/config.yml id:rv_yaml_vouchers
        - run roseate_vouchers_yaml_loader

roseate_vouchers_yaml_loader:
    debug: false
    type: task
    script:
    - foreach <yaml[rv_yaml_vouchers].list_keys[RoseateVouchers.Vouchers]> as:voucher_types:
        - define yaml_voucher_load rv_voucher_<[voucher_types]>
        - if <yaml.list.contains[<[yaml_voucher_load]>]>:
            - ~yaml unload id:rv_voucher_<[voucher_types]>
        - if <yaml[rv_yaml_vouchers].read[RoseateVouchers.Vouchers.<[voucher_types]>.Enabled]>:
            - if <server.has_file[../RoseateVouchers/Vouchers/<[voucher_types]>.yml]>:
                - ~yaml load:../RoseateVouchers/Vouchers/<[voucher_types]>.yml id:rv_voucher_<[voucher_types]>
            - else:
                - define NotDefined "Not Defined"
                - define NonCommand "say Please insert a command."
                - yaml create id:rv_voucher_<[voucher_types]>
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Display:<[NotDefined]>
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Internal_ID:<[voucher_types]>
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Item.Icon:book
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Item.Model:0
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Lore[1]:<[NotDefined]>
                - yaml id:rv_voucher_<[voucher_types]> set <[voucher_types]>.Effects.Commands[1]:<[NonCommand]>
                - ~yaml savefile:../RoseateVouchers/Vouchers/<[voucher_types]>.yml id:rv_voucher_<[voucher_types]>

roseate_vouchers_command:
    debug: false
    type: command
    name: voucher
    description: Voucher give command
    usage: /voucher
    permissions: rose-vouchers.core.admin
    tab completions:
        1: give|reload
        2: <server.online_players.parse[name]>
        4: 1
    tab complete:
    - define list <list>
    - if <context.args.size> == 2 && <context.args.get[1]> == give:
        - foreach <yaml[rv_yaml_vouchers].list_keys[RoseateVouchers.Vouchers]> as:vouchers:
            - if <yaml[rv_yaml_vouchers].read[RoseateVouchers.Vouchers.<[vouchers]>.Enabled]>:
                - define list <[list].include[<[vouchers]>]>
        - determine <[list]>
    script:
    - if <context.args.size> == 4 && <context.args.get[1]> == give:
        - define player  <server.match_player[<context.args.get[2]>]>
        - define voucher <context.args.get[3]>
        - define amount  <context.args.get[4]>
        - if <yaml[rv_yaml_vouchers].read[RoseateVouchers.Vouchers.<[voucher]>.Enabled].if_null[false]> && <server.has_file[../RoseateVouchers/Vouchers/<[voucher]>.yml]>:
            - define icon  <yaml[rv_voucher_<[voucher]>].read[<[voucher]>.Item.Icon].if_null[book]>
            - define model <yaml[rv_voucher_<[voucher]>].read[<[voucher]>.Item.Model].if_null[0]>
            - define name  <yaml[rv_voucher_<[voucher]>].read[<[voucher]>.Display].if_null[Unknown]>
            - define flag  <yaml[rv_voucher_<[voucher]>].read[<[voucher]>.Internal_ID].if_null[invalid]>
            - define lore  <yaml[rv_voucher_<[voucher]>].parsed_key[<[voucher]>.Lore].if_null[Empty].parsed>
            - define item  <item[<[icon]>].with[display_name=<[name].parsed>;lore=<[lore]>;hides=ALL;custom_model_data=<[model]>].with_flag[voucher:<[flag]>]>
            #- if <[player].inventory.can_fit[<[item]>].quantity[<[amount]>]>:
            - give <[item]> quantity:<[amount]> to:<[player].inventory>
            - narrate "<&color[#735656]><&color[l]>[<&color[#D9C69C]>🔥<&color[#735656]><&color[l]>] <&color[#D9C69C]>Granted [<[amount]><&color[#D9C69C]>]x of [<[name].parsed><&color[#D9C69C]>] to <[player].name>."
            #- else:
            #    - narrate "<&color[#735656]><&color[l]>[<&color[#D9C69C]>🔥<&color[#735656]><&color[l]>] <&color[#D9C69C]>This user's inventory is full."
        - else:
            - narrate "<&color[#735656]><&color[l]>[<&color[#D9C69C]>🔥<&color[#735656]><&color[l]>] <&color[#D9C69C]>Invalid or not loaded voucher."
    - if <context.args.size> == 1 && <context.args.get[1]> == reload:
        - run roseate_vouchers_yaml_handler
        - narrate "<&color[#735656]><&color[l]>[<&color[#D9C69C]>🔥<&color[#735656]><&color[l]>] <&color[#D9C69C]>Voucher system reloaded!"

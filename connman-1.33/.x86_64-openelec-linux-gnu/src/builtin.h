extern struct connman_plugin_desc __connman_builtin_loopback;
extern struct connman_plugin_desc __connman_builtin_ethernet;
extern struct connman_plugin_desc __connman_builtin_wifi;

static struct connman_plugin_desc *__connman_builtin[] = {
  &__connman_builtin_loopback,
  &__connman_builtin_ethernet,
  &__connman_builtin_wifi,
  NULL
};

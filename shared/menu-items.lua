MenuItems = {
    {
        id = "engine",
        title = "Engine",
        icon = "engine",
        close = true,
        data = {
            event = {
                client = {
                    name = "glz_veh:engine"
                }
            }
        }
    },
    {
        id = "carlock",
        title = "Carlock",
        icon = "key",
        close = true,
        data = {
            command = "carlock"
        }
    },
    {
        id = "doors",
        title = "Doors",
        icon = "veh-doors",
        items = {
            {
                id = "doorFL",
                title = {"Front Left", "Door"},
                -- icon = "veh-door-left",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {0}
                        }
                    }
                }
            },
            {
                id = "hood",
                title = "Hood",
                icon = "hood",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {4}
                        }
                    }
                }
            },
            {
                id = "doorFR",
                title = {"Front Right", "Door"},
                -- icon = "veh-door-right",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {1}
                        }
                    }
                }
            },
            {
                id = "doorRR",
                title = {"Rear Right", "Door"},
                -- icon = "veh-door-right",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {3}
                        }
                    }
                }
            },
            {
                id = "trunk",
                title = "Trunk",
                icon = "trunk",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {5}
                        }
                    }
                }
            },
            {
                id = "doorRL",
                title = {"Rear Left", "Door"},
                -- icon = "veh-door-left",
                data = {
                    event = {
                        client = {
                            name = "glz_veh:door",
                            args = {2}
                        }
                    }
                }
            }
        }
    },
    {
        id = "neons",
        title = "Neons",
        icon = "neon",
        close = true,
        data = {
            event = {
                client = {
                    name = "glz_veh:neons"
                }
            }
        }
    },
    {
        id = "switchJob",
        title = "Switch Vehicle Job",
        icon = "arrow-right-arrow-left",
        close = true,
        data = {
            command = "switchvehiclejob"
        }
    }
}
import { Component, OnInit, Input } from '@angular/core';
import { Ifile } from '../ifile';
import { OnlydirPipe } from '../onlydir';

@Component({
  selector: 'hxtreeview',
  templateUrl: './hxtreeview.component.html',
  styleUrls: ['./hxtreeview.component.css']
})
export class HxtreeviewComponent implements OnInit {
  @Input() ifiles: Array<Ifile> = [];
  ifilesOnlyDir: Array<Ifile> = [];
  treeActive: boolean = false;

  public list = [
    {
      "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/config",
      "name": "config",
      "children": [
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/config/postcss.config.js",
          "name": "postcss.config.js",
          "size": 238,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/config/rollup.config.js",
          "name": "rollup.config.js",
          "size": 610,
          "extension": ".js",
          "type": "file"
        }
      ],
      "size": 848,
      "type": "directory"
    },
    {
      "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js",
      "name": "js",
      "children": [
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/.jscsrc",
          "name": ".jscsrc",
          "size": 2219,
          "extension": "",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/AdminLTE.js",
          "name": "AdminLTE.js",
          "size": 498,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/CardRefresh.js",
          "name": "CardRefresh.js",
          "size": 4191,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/CardWidget.js",
          "name": "CardWidget.js",
          "size": 7021,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/ControlSidebar.js",
          "name": "ControlSidebar.js",
          "size": 9402,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/DirectChat.js",
          "name": "DirectChat.js",
          "size": 2043,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/Dropdown.js",
          "name": "Dropdown.js",
          "size": 3441,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/Layout.js",
          "name": "Layout.js",
          "size": 7119,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/PushMenu.js",
          "name": "PushMenu.js",
          "size": 5613,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/SiteSearch.js",
          "name": "SiteSearch.js",
          "size": 2922,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/Toasts.js",
          "name": "Toasts.js",
          "size": 6193,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/TodoList.js",
          "name": "TodoList.js",
          "size": 2496,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/js/Treeview.js",
          "name": "Treeview.js",
          "size": 4649,
          "extension": ".js",
          "type": "file"
        }
      ],
      "size": 57807,
      "type": "directory"
    },
    {
      "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/npm",
      "name": "npm",
      "children": [
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/npm/DocsPlugins.js",
          "name": "DocsPlugins.js",
          "size": 1025,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/npm/DocsPublish.js",
          "name": "DocsPublish.js",
          "size": 820,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/npm/Plugins.js",
          "name": "Plugins.js",
          "size": 9443,
          "extension": ".js",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/npm/Publish.js",
          "name": "Publish.js",
          "size": 967,
          "extension": ".js",
          "type": "file"
        }
      ],
      "size": 12255,
      "type": "directory"
    },
    {
      "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss",
      "name": "scss",
      "children": [
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/.csslintrc",
          "name": ".csslintrc",
          "size": 544,
          "extension": "",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-components.scss",
          "name": "AdminLTE-components.scss",
          "size": 548,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-core.scss",
          "name": "AdminLTE-core.scss",
          "size": 530,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-extra-components.scss",
          "name": "AdminLTE-extra-components.scss",
          "size": 560,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-pages.scss",
          "name": "AdminLTE-pages.scss",
          "size": 531,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-plugins.scss",
          "name": "AdminLTE-plugins.scss",
          "size": 542,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE-raw.scss",
          "name": "AdminLTE-raw.scss",
          "size": 950,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/AdminLTE.scss",
          "name": "AdminLTE.scss",
          "size": 624,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_alerts.scss",
          "name": "_alerts.scss",
          "size": 608,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_bootstrap-variables.scss",
          "name": "_bootstrap-variables.scss",
          "size": 37074,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_brand.scss",
          "name": "_brand.scss",
          "size": 1408,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_buttons.scss",
          "name": "_buttons.scss",
          "size": 2019,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_callout.scss",
          "name": "_callout.scss",
          "size": 916,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_cards.scss",
          "name": "_cards.scss",
          "size": 7438,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_carousel.scss",
          "name": "_carousel.scss",
          "size": 302,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_colors.scss",
          "name": "_colors.scss",
          "size": 1655,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_control-sidebar.scss",
          "name": "_control-sidebar.scss",
          "size": 3011,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_direct-chat.scss",
          "name": "_direct-chat.scss",
          "size": 3562,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_dropdown.scss",
          "name": "_dropdown.scss",
          "size": 4691,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_elevation.scss",
          "name": "_elevation.scss",
          "size": 212,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_forms.scss",
          "name": "_forms.scss",
          "size": 5589,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_info-box.scss",
          "name": "_info-box.scss",
          "size": 2440,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_layout.scss",
          "name": "_layout.scss",
          "size": 12503,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_main-header.scss",
          "name": "_main-header.scss",
          "size": 2598,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_main-sidebar.scss",
          "name": "_main-sidebar.scss",
          "size": 18170,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_miscellaneous.scss",
          "name": "_miscellaneous.scss",
          "size": 7256,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_mixins.scss",
          "name": "_mixins.scss",
          "size": 274,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_modals.scss",
          "name": "_modals.scss",
          "size": 564,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_navs.scss",
          "name": "_navs.scss",
          "size": 1983,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_print.scss",
          "name": "_print.scss",
          "size": 904,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_products.scss",
          "name": "_products.scss",
          "size": 759,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_progress-bars.scss",
          "name": "_progress-bars.scss",
          "size": 871,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_sidebar-mini.scss",
          "name": "_sidebar-mini.scss",
          "size": 2870,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_small-box.scss",
          "name": "_small-box.scss",
          "size": 2248,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_social-widgets.scss",
          "name": "_social-widgets.scss",
          "size": 1447,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_table.scss",
          "name": "_table.scss",
          "size": 1262,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_text.scss",
          "name": "_text.scss",
          "size": 502,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_timeline.scss",
          "name": "_timeline.scss",
          "size": 2348,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_toasts.scss",
          "name": "_toasts.scss",
          "size": 745,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_users-list.scss",
          "name": "_users-list.scss",
          "size": 617,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/_variables.scss",
          "name": "_variables.scss",
          "size": 9420,
          "extension": ".scss",
          "type": "file"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins",
          "name": "mixins",
          "children": [
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_accent.scss",
              "name": "_accent.scss",
              "size": 2352,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_backgrounds.scss",
              "name": "_backgrounds.scss",
              "size": 1543,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_cards.scss",
              "name": "_cards.scss",
              "size": 1485,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_custom-forms.scss",
              "name": "_custom-forms.scss",
              "size": 1866,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_direct-chat.scss",
              "name": "_direct-chat.scss",
              "size": 306,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_miscellaneous.scss",
              "name": "_miscellaneous.scss",
              "size": 874,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_navbar.scss",
              "name": "_navbar.scss",
              "size": 644,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_sidebar.scss",
              "name": "_sidebar.scss",
              "size": 3449,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/mixins/_toasts.scss",
              "name": "_toasts.scss",
              "size": 394,
              "extension": ".scss",
              "type": "file"
            }
          ],
          "size": 12913,
          "type": "directory"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages",
          "name": "pages",
          "children": [
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_404_500_errors.scss",
              "name": "_404_500_errors.scss",
              "size": 672,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_e-commerce.scss",
              "name": "_e-commerce.scss",
              "size": 764,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_invoice.scss",
              "name": "_invoice.scss",
              "size": 159,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_lockscreen.scss",
              "name": "_lockscreen.scss",
              "size": 1145,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_login_and_register.scss",
              "name": "_login_and_register.scss",
              "size": 1596,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_mailbox.scss",
              "name": "_mailbox.scss",
              "size": 1300,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_profile.scss",
              "name": "_profile.scss",
              "size": 485,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/pages/_projects.scss",
              "name": "_projects.scss",
              "size": 319,
              "extension": ".scss",
              "type": "file"
            }
          ],
          "size": 6440,
          "type": "directory"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts",
          "name": "parts",
          "children": [
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_components.scss",
              "name": "_components.scss",
              "size": 245,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_core.scss",
              "name": "_core.scss",
              "size": 214,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_extra-components.scss",
              "name": "_extra-components.scss",
              "size": 206,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_miscellaneous.scss",
              "name": "_miscellaneous.scss",
              "size": 142,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_pages.scss",
              "name": "_pages.scss",
              "size": 271,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/parts/_plugins.scss",
              "name": "_plugins.scss",
              "size": 419,
              "extension": ".scss",
              "type": "file"
            }
          ],
          "size": 1497,
          "type": "directory"
        },
        {
          "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins",
          "name": "plugins",
          "children": [
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_bootstrap-slider.scss",
              "name": "_bootstrap-slider.scss",
              "size": 489,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_bootstrap-switch.scss",
              "name": "_bootstrap-switch.scss",
              "size": 4457,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_fullcalendar.scss",
              "name": "_fullcalendar.scss",
              "size": 1833,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_icheck-bootstrap.scss",
              "name": "_icheck-bootstrap.scss",
              "size": 1566,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_jqvmap.scss",
              "name": "_jqvmap.scss",
              "size": 447,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_mapael.scss",
              "name": "_mapael.scss",
              "size": 1339,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_miscellaneous.scss",
              "name": "_miscellaneous.scss",
              "size": 572,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_mixins.scss",
              "name": "_mixins.scss",
              "size": 1679,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_pace.scss",
              "name": "_pace.scss",
              "size": 3982,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_select2.scss",
              "name": "_select2.scss",
              "size": 5696,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_sweetalert2.scss",
              "name": "_sweetalert2.scss",
              "size": 647,
              "extension": ".scss",
              "type": "file"
            },
            {
              "path": "/Users/herux/Downloads/AdminLTE-3.0.5/build/scss/plugins/_toastr.scss",
              "name": "_toastr.scss",
              "size": 1203,
              "extension": ".scss",
              "type": "file"
            }
          ],
          "size": 23910,
          "type": "directory"
        }
      ],
      "size": 187855,
      "type": "directory"
    }
  ]

  constructor(private onlyDir: OnlydirPipe) { }

  clickFolder(event, index) {
    let ulElem = event.target.querySelector('ul');
    let iconElem = event.target.querySelector('i');
    if (iconElem.className == 'fas fa-folder') {
      iconElem.className = 'fas fa-folder-open';
      this.treeActive = true;
    }else{
      iconElem.className = 'fas fa-folder';
      this.treeActive = false;
    }
  }

  ngOnInit(): void {
    this.ifilesOnlyDir = this.onlyDir.transform(this.ifiles);
    console.log('this.ifilesOnlyDir: ', JSON.stringify(this.ifilesOnlyDir));
  }

}

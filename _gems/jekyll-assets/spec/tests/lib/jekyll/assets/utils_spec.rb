# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Utils do
  subject do
    env
  end

  #

  describe "#external?" do
    context "w/out external" do
      context "w/ relative" do
        it "true" do
          out = env.external?(argv1: "img.png")
          expect(out).to(eq(false))
        end
      end

      #

      context "w/ absolute" do
        it "false" do
          out = env.external?(argv1: "/hello.world")
          expect(out).to eq(false)
        end
      end

      #

      context "w/ http" do
        it "true" do
          out = env.external?(argv1: "http://hello.world")
          expect(out).to eq(true)
        end
      end

      #

      context "w/ https" do
        it "true" do
          out = env.external?(argv1: "https://hello.world")
          expect(out).to eq(true)
        end
      end

      #

      context "w/ //" do
        it "true" do
          out = env.external?(argv1: "//hello.world")
          expect(out).to eq(true)
        end
      end
    end

    #

    context "w/ external: true" do
      let :args do
        {
          external: true,
        }
      end

      #

      context "w/ absolute" do
        it "true" do
          out = env.external?(args.merge(argv1: "/hello.world"))
          expect(out).to eq(true)
        end
      end

      #

      context "w/ http" do
        it "true" do
          out = env.external?(args.merge(argv1: "http://hello.world"))
          expect(out).to eq(true)
        end
      end

      #

      context "w/ https" do
        it "true" do
          out = env.external?(args.merge(argv1: "https://hello.world"))
          expect(out).to eq(true)
        end
      end

      #

      context "w/ //" do
        it "true" do
          out = env.external?(args.merge(argv1: "//hellow.world"))
          expect(out).to eq(true)
        end
      end
    end
  end

  #

  describe "#parse_liquid" do
    context "a page" do
      let :page do
        site.pages.find do |v|
          v.path == "utils/parse_liquid/ctx.html"
        end
      end

      #

      it "parses" do
        expect(page.output).to match(%r!<img!)
      end

      #

      context "with an assign" do
        let :page do
          site.pages.find do |v|
            v.path == "utils/parse_liquid/assign.html"
          end
        end

        #

        it "works" do
          expect(page.output).to match(%r!<img!)
          expect(page.output).to \
            match(%r!\.png!)
        end
      end
    end

    context "w/ {}" do
      it "parses" do
        expect(env.parse_liquid({ hello: "{{ site }}" }, ctx: Thief.ctx))
          .to eq({
            hello: "Jekyll::Drops::SiteDrop",
          })
      end

      context "with nested {}" do
        it "parses" do
          hash = { magick: { quality: "{{ var }}" } }
          expect(env.parse_liquid(hash, ctx: Thief.ctx))
            .to eq({
              magick: {
                quality: "val",
              },
            })
        end
      end
    end

    #

    context "w/ []" do
      it "parses" do
        expect(env.parse_liquid(["{{ site }}"], ctx: Thief.ctx)).to eq([
          "Jekyll::Drops::SiteDrop",
        ])
      end
    end

    #

    context "w/ String" do
      it "parses" do
        expect(env.parse_liquid("{{ site }}", ctx: Thief.ctx)).to eq(
          "Jekyll::Drops::SiteDrop")
      end
    end
  end

  #

  describe "#in_cache_dir" do
    context "w/ asset_config[:caching][:path]" do
      before do
        stub_asset_config({
          caching: {
            path: "hello-cache",
          },
        })
      end

      #

      it "uses it" do
        expect(subject.in_cache_dir.to_s).to \
          end_with("/hello-cache")
      end
    end

    #

    it "allows paths" do
      expect(subject.in_cache_dir("one", "two").to_s).to \
        end_with("one/two")
    end
  end

  #

  describe "#in_dest_dir" do
    context "w/ asset_config[:destination]" do
      before do
        stub_asset_config({
          destination: "/hello",
        })
      end

      #

      it "uses it" do
        rtn = subject.in_dest_dir
        expect(rtn.to_s).to end_with("/hello")
      end
    end

    #

    it "in site dir" do
      rtn = subject.in_dest_dir
      expect(rtn.to_s).to start_with(jekyll
        .in_dest_dir.to_s)
    end

    #

    it "allows paths" do
      rtn = subject.in_dest_dir("one", "two")
      expect(rtn.to_s).to end_with("one/two")
    end
  end

  #

  describe "#prefix_url" do
    let :cdn do
      "https://hello.cdn"
    end

    #

    before do
      stub_asset_config({
        cdn: {
          url: cdn,
        },
      })
    end

    context ":full_url" do
      context "when true" do
        before do
          stub_asset_config({
            full_url: true,
            cdn: {
              url: nil
            },
          })
        end

        it "should prefix with the hostname" do
          expect(subject.prefix_url).to start_with(
            "http://127.0.0.1:4000"
          )
        end
      end

      context "when false" do
        before do
          stub_asset_config({
            full_url: false,
            cdn: {
              url: nil
            },
          })
        end

        it "should not prefix" do
          expect(subject.prefix_url).not_to start_with(
            "http://"
          )
        end
      end
    end

    #

    context "production" do
      before do
        allow(Jekyll).to receive(:dev?).and_return(false)
        allow(Jekyll).to receive(:production?)
          .and_return(true)
      end

      #

      context "w/ asset_config[:cdn][:url]" do
        it "uses it" do
          out = subject.prefix_url
          expect(out).to start_with(cdn)
        end
      end

      context "jekyll.config[:baseurl]" do
        before do
          stub_jekyll_config({
            baseurl: "hello",
          })
        end

        #

        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil,
              },
            })
          end

          #

          it "uses it" do
            out = subject.prefix_url
            expect(out).to start_with(
              "/hello"
            )
          end
        end

        #

        context "w/ asset_config[:cdn][:url]" do
          context "asset_config[:cdn][:baseurl]" do
            context "w/ true" do
              before do
                stub_asset_config({
                  cdn: {
                    baseurl: true,
                  },
                })
              end

              #

              it "uses it" do
                out = subject.prefix_url
                expect(out).to end_with("/hello")
              end
            end

            #

            context "w/ false" do
              it "doesn't use it" do
                out = subject.prefix_url
                expect(out).not_to end_with("/hello")
              end
            end
          end
        end
      end

      #

      context "asset_config[:destination]" do
        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil,
              },
            })
          end

          #

          it "uses it" do
            out = subject.prefix_url
            destination = subject.asset_config[:destination]
            expect(out).to eq(destination)
          end
        end

        #

        context "w/ asset_config[:cdn][:destination]" do
          context "w/ true" do
            before do
              stub_asset_config({
                cdn: {
                  destination: true,
                },
              })
            end

            #

            it "uses it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).to end_with(destination)
            end
          end

          #

          context "w/ false" do
            it "doesn't use it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).not_to end_with(destination)
            end
          end
        end
      end
    end
  end

  #

  describe "#strip_secondary_content_type" do
    context "w/ text/liquid+css" do
      it "works" do
        out = described_class.strip_secondary_content_type("text/liquid+css")
        expect(out).to(eq("text/css"))
      end
    end

    context "w/ image/liquid+svg+xml" do
      it "works" do
        out = described_class.strip_secondary_content_type("image/liquid+svg+xml")
        expect(out).to(eq("image/svg+xml"))
      end
    end
  end
end
